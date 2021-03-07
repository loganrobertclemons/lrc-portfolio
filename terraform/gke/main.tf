
locals {
  gitlab_db_name = "${var.gitlab_db_name}-${random_id.suffix.hex}"
}

module "gke_auth" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version = "~> 9.1"

  project_id   = module.project_services.project_id
  cluster_name = module.gke.name
  location     = module.gke.location

  depends_on = [time_sleep.sleep_for_cluster_fix_helm_6361]
}

provider "kubernetes" {
  load_config_file       = false
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  host                   = module.gke_auth.host
  token                  = module.gke_auth.token
}

provider "helm" {
  kubernetes {
    load_config_file       = false
    cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
    host                   = module.gke_auth.host
    token                  = module.gke_auth.token
  }
}

resource "google_project_service" "project" {
  project            = var.project_id
  disable_on_destroy = "false"
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ])
  service = each.value
}

# project api enablement
module "project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 9.0"
  disable_services_on_destroy = "false"
  project_id                  = var.project_id

  activate_apis = [
    "iam.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "redis.googleapis.com",
    "monitoring.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com"
  ]
}

// GCS Service Account
resource "google_service_account" "gitlab_gcs" {
  project      = var.project_id
  account_id   = "gitlab-gcs"
  display_name = "GitLab Cloud Storage"
  depends_on   = [module.project_services]
}

resource "google_service_account_key" "gitlab_gcs" {
  service_account_id = google_service_account.gitlab_gcs.name
  depends_on         = [module.project_services]
}

resource "google_project_iam_member" "project" {
  project    = var.project_id
  role       = "roles/storage.admin"
  member     = "serviceAccount:${google_service_account.gitlab_gcs.email}"
  depends_on = [module.project_services]
}

// Networking
resource "google_compute_network" "gitlab" {
  name                    = "gitlab"
  project                 = module.project_services.project_id
  auto_create_subnetworks = false
  depends_on              = [module.project_services]
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "gitlab"
  ip_cidr_range = var.gitlab_nodes_subnet_cidr
  region        = var.region
  network       = google_compute_network.gitlab.self_link
  depends_on    = [module.project_services]


  secondary_ip_range {
    range_name    = "gitlab-cluster-pod-cidr"
    ip_cidr_range = var.gitlab_pods_subnet_cidr
  }

  secondary_ip_range {
    range_name    = "gitlab-cluster-service-cidr"
    ip_cidr_range = var.gitlab_services_subnet_cidr
  }
}

resource "google_compute_address" "gitlab" {
  name         = "gitlab"
  region       = var.region
  address_type = "EXTERNAL"
  description  = "Gitlab Ingress IP"
  depends_on   = [module.project_services, google_compute_address.nginx]
  count        = var.gitlab_address_name == "" ? 1 : 0
}

// Database
resource "google_compute_global_address" "gitlab_sql" {
  provider      = google-beta
  project       = module.project_services.project_id
  name          = "gitlab-sql"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  network       = google_compute_network.gitlab.self_link
  address       = "10.1.0.0"
  prefix_length = 16
  depends_on    = [module.project_services]

}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = google_compute_network.gitlab.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.gitlab_sql.name]
  depends_on              = [module.project_services]
}

# creates nginx external IP
resource "google_compute_address" "nginx" {
  name         = var.nginx_address_name
  project      = module.project_services.project_id
  region       = var.region
  address_type = "EXTERNAL"
  description  = "Nginx Ingress IP"
  depends_on   = [module.project_services]
}

resource "google_sql_database_instance" "gitlab_db" {
  depends_on          = [google_service_networking_connection.private_vpc_connection, module.project_services]
  name                = local.gitlab_db_name
  region              = var.region
  project             = module.project_services.project_id
  database_version    = "POSTGRES_11"
  deletion_protection = "false"

  settings {
    tier            = "db-custom-4-15360"
    disk_autoresize = true

    ip_configuration {
      ipv4_enabled    = "false"
      private_network = google_compute_network.gitlab.self_link
    }
  }
}

resource "google_sql_database" "gitlabhq_production" {
  name       = "gitlabhq_production"
  instance   = google_sql_database_instance.gitlab_db.name
  depends_on = [google_sql_user.gitlab, module.project_services]
  project    = module.project_services.project_id
}

resource "random_string" "autogenerated_gitlab_db_password" {
  length  = 16
  special = false
}

resource "google_sql_user" "gitlab" {
  name       = "gitlab"
  instance   = google_sql_database_instance.gitlab_db.name
  depends_on = [module.project_services]
  password   = var.gitlab_db_password != "" ? var.gitlab_db_password : random_string.autogenerated_gitlab_db_password.result
}

// Redis
resource "google_redis_instance" "gitlab" {
  name               = "gitlab"
  tier               = "STANDARD_HA"
  memory_size_gb     = 5
  region             = var.region
  authorized_network = google_compute_network.gitlab.self_link

  depends_on = [module.project_services]

  display_name = "GitLab Redis"
}

// Cloud Storage
resource "google_storage_bucket" "gitlab-backups" {
  name          = "${var.project_id}-gitlab-backups"
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "gitlab-uploads" {
  name          = "${var.project_id}-gitlab-uploads"
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "gitlab-artifacts" {
  name          = "${var.project_id}-gitlab-artifacts"
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "git-lfs" {
  name          = "${var.project_id}-git-lfs"
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "gitlab-packages" {
  name          = "${var.project_id}-gitlab-packages"
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "gitlab-registry" {
  name          = "${var.project_id}-registry"
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "gitlab-pseudo" {
  name          = "${var.project_id}-pseudo"
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "gitlab-runner-cache" {
  name          = "${var.project_id}-runner-cache"
  force_destroy = true
  location      = var.region
}

// GKE Cluster
module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 12.0"

  # Create an implicit dependency on service activation
  project_id = module.project_services.project_id

  name               = var.cluster_name
  region             = var.region
  regional           = true
  kubernetes_version = var.gke_version

  remove_default_node_pool = true
  initial_node_count       = 1

  network           = google_compute_network.gitlab.name
  subnetwork        = google_compute_subnetwork.subnetwork.name
  ip_range_pods     = "gitlab-cluster-pod-cidr"
  ip_range_services = "gitlab-cluster-service-cidr"

  issue_client_certificate = true

  node_pools = [
    {
      name         = var.cluster_name
      autoscaling  = false
      machine_type = var.gke_machine_type
      node_count   = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}