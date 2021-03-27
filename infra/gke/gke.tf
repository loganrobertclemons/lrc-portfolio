# Allows management of a single API service for an existing Google Cloud Platform project.
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

# Project api enablement
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

module "gke_auth" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version = "~> 9.1"

  project_id   = module.project_services.project_id
  cluster_name = module.gke.name
  location     = module.gke.location
}

# GKE Cluster
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

  network           = google_compute_network.gitlab_network.name
  subnetwork        = google_compute_subnetwork.gitlab_subnetwork.name
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