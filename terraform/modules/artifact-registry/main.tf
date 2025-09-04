variable "project_id" {}
variable "region" {}
variable "env" {}

resource "google_artifact_registry_repository" "idp_images" {
  provider      = google-beta
  project       = var.project_id
  location      = var.region
  repository_id = "${var.env}-idp-images"
  description   = "Artifact Registry for ${var.env} services"
  format        = "DOCKER"
}

output "artifact_registry_repo" {
  value = google_artifact_registry_repository.idp_images.repository_id
}
