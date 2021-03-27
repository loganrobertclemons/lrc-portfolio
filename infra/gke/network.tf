# Networking
resource "google_compute_network" "gitlab_network" {
  name                    = format("%s-gitlab-compute-network", var.cluster_name)
  project                 = module.project_services.project_id
  auto_create_subnetworks = false
  depends_on              = [module.project_services]
}

resource "google_compute_subnetwork" "gitlab_subnetwork" {
  name          = format("%s-gitlab-compute-subnet", var.cluster_name)
  ip_cidr_range = var.gitlab_nodes_subnet_cidr
  region        = var.region
  network       = google_compute_network.gitlab_network.self_link
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

resource "google_compute_address" "gitlab_address" {
  name         = format("%s-gitlab-compute-address", var.cluster_name)
  region       = var.region
  address_type = "EXTERNAL"
  description  = "Gitlab Ingress IP"
  depends_on   = [module.project_services, google_compute_address.nginx]
  count        = var.gitlab_address_name == "" ? 1 : 0
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
