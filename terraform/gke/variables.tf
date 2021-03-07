variable "project_id" {
  description = "GCP Project to deploy resources"
}

variable "region" {
  description = "GCP region to deploy resources to"
  default     = "us-central1"
}

variable "google_credentials" {
  type = string
}

variable "gke_version" {
  description = "Version of GKE to use for the GitLab cluster"
  default     = "1.16"
}

variable "cluster_name" {
  type = string
}

variable "gke_machine_type" {
  description = "Machine type used for the node-pool"
  default     = "n1-standard-4"
}