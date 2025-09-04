variable "project_id" {
  description = "GCP project ID"
}

variable "region" {
  description = "GCP region"
  default     = "us-central1"
}

variable "env" {
  description = "Deployment environment (development, staging, production)"
}

variable "service_repos" {
  description = "Map of service repos { name = repo_url }"
  type        = map(string)
  default     = {}
}

variable "db_password_secret" {
  description = "Secret Manager ID for Cloud SQL DB password"
  type        = string
}

variable "argocd_password_secret" {
  description = "Secret Manager ID for ArgoCD admin password"
  type        = string
}

variable "node_disk_type" {
  description = "Disk type for GKE nodes (pd-standard, pd-ssd, pd-balanced, hyperdisk-balanced)"
  type        = string
  default     = "pd-standard"
}

variable "node_disk_size_gb" {
  description = "Disk size (GB) for GKE nodes"
  type        = number
  default     = 100
}


# ------------------------------
# GKE Node Disk Configuration
# ------------------------------
