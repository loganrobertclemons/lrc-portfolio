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