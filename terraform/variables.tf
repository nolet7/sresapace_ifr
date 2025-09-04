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

