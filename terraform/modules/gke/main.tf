variable "project_id" {}
variable "region" {
  default = "us-central1"
}
variable "env" {}
variable "node_disk_type" {}
variable "node_disk_size_gb" {}

resource "google_container_cluster" "primary" {
  name     = "${var.env}-idp-cluster"
  location = var.region
  project  = var.project_id

  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }

  deletion_protection = true
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.env}-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = 2

  node_config {
    machine_type = "e2-medium"

    # ✅ Controlled via variables
    disk_type    = var.node_disk_type
    disk_size_gb = var.node_disk_size_gb

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

output "gke_cluster_name" {
  value = google_container_cluster.primary.name
}

