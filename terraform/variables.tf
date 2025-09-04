variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "service_repos" {
  description = "List of service repositories for Argo CD"
  type        = list(string)
  default     = []
}
