output "region" {
  value       = var.region
  description = "GCP Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCP Project ID"
}

output "root_password_instructions" {
  value = <<EOF
  Run the following commands to get the root user password:
  gcloud container clusters get-credentials gitlab --zone ${var.region} --project ${var.project_id}
  kubectl get secret gitlab-gitlab-initial-root-password -o go-template='{{ .data.password }}' | base64 -d && echo
  EOF

  description = "Instructions for getting the root user's password for initial setup"
}