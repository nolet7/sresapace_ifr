variable "project_id" {}
variable "region" {}
variable "env" {}

resource "google_container_cluster" "primary" {
  name     = "${var.env}-idp-cluster"
  location = var.region
  project  = var.project_id

  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = "REGULAR"
  }

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {}

  # Enable Workload Identity
  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.env}-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  project    = var.project_id

  node_count = 2

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

output "gke_cluster_name" {
  value = google_container_cluster.primary.name
}
<--- paste GKE module code here --->
