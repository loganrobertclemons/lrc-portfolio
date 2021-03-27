// Cloud Storage
resource "google_storage_bucket" "gitlab-backups" {
  name          = format("%s-gitlab-backups", var.project_id)
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "gitlab-uploads" {
  name          = format("%s-gitlab-uploads", var.project_id)
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "gitlab-artifacts" {
  name          = format("%s-gitlab-artifacts", var.project_id)
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "git-lfs" {
  name          = format("%s-gitlab-lfs", var.project_id)
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "gitlab-packages" {
  name          = format("%s-gitlab-packages", var.project_id)
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "gitlab-registry" {
  name          = format("%s-gitlab-registry", var.project_id)
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "gitlab-pseudo" {
  name          = format("%s-gitlab-pseudo", var.project_id)
  force_destroy = true
  location      = var.region
}

resource "google_storage_bucket" "gitlab-runner-cache" {
  name          = format("%s-gitlab-runner-cache", var.project_id)
  force_destroy = true
  location      = var.region
}