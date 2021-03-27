# GCP project ID where gke cluster will live
variable "project_id" {
  description = "GCP Project to deploy resources"
  default = "lrc-portfolio-1138"
}

variable "region" {
  description = "GCP region to deploy resources to"
  default     = "us-central1"
}

variable "cluster_name" {
  description = "GKE cluster name"
  type = string
  default = "lrc-portfolio-cluster"
}

# Stable is at 1.16 and eventually will move to 1.19
variable "gke_version" {
  description = "Version of GKE to use for the GitLab cluster"
  default     = "1.18"
}

variable "gke_machine_type" {
  description = "Machine type used for the node-pool"
  default     = "n2-standard-2"
}

variable "gitlab_nodes_subnet_cidr" {
  description = "Cidr range to use for gitlab GKE nodes subnet"
  default     = "10.0.0.0/16"
}

variable "gitlab_pods_subnet_cidr" {
  description = "Cidr range to use for gitlab GKE pods subnet"
  default     = "10.3.0.0/16"
}

variable "gitlab_services_subnet_cidr" {
  description = "Cidr range to use for gitlab GKE services subnet"
  default     = "10.2.0.0/16"
}

variable "gitlab_address_name" {
  description = "Name of the address to use for GitLab ingress"
  default     = ""
}

variable "gitlab_db_name" {
  description = "Instance name for the GitLab Postgres database."
  default     = "gitlab-db"
}

variable "gitlab_db_password" {
  description = "Password for the GitLab Postgres user"
  default     = ""
}

variable "domain" {
  description = "Domain for hosting gitlab functionality (ie mydomain.com would access gitlab at gitlab.mydomain.com)"
  default     = ""
}

variable "nginx_address_name" {
  description = "Name of the address to use for GitLab ingress"
  default     = "nginx"
}

variable "email_address" {
  description = "Email used to retrieve SSL certificates from Let's Encrypt"
  default = "loganrclemons@gmail.com"
}

variable "gitlab_runner_install" {
  description = "Choose whether to install the gitlab runner in the cluster"
  default     = false
}

variable "gitlab_helm_chart_version" {
  description = "Helm chart version to install during deployment"
  type        = string
  default     = "4.6.0"
}

variable "username" {
  description = "Github username"
  type        = string
  default = "loganrobertclemons"
}

variable "repo" {
  description = "Github repo connected to flux"
  type        = string
  default = "https://github.com/loganrobertclemons/lrc-portfolio.git"
}
