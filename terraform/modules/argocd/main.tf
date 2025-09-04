variable "project_id" {}
variable "region" {}
variable "env" {}

variable "argocd_password_secret" {
  description = "Secret Manager ID for the ArgoCD admin password"
}

variable "argocd_password" {
  description = "Initial ArgoCD password (used only if secret is missing)"
  default     = null
}

# Ensure secret exists (replication is auto)
resource "google_secret_manager_secret" "argocd_password" {
  project   = var.project_id
  secret_id = var.argocd_password_secret

  replication {
    auto {}
  }
}

# Add secret version (only if argocd_password is provided)
resource "google_secret_manager_secret_version" "argocd_password" {
  count       = var.argocd_password != null ? 1 : 0
  secret      = google_secret_manager_secret.argocd_password.id
  secret_data = var.argocd_password
}

# Fetch latest password
data "google_secret_manager_secret_version" "argocd_password" {
  project = var.project_id
  secret  = var.argocd_password_secret
  version = "latest"
}

# Deploy ArgoCD via Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.8"

  create_namespace = true

  values = [<<EOT
configs:
  secret:
    argocdServerAdminPassword: "${data.google_secret_manager_secret_version.argocd_password.secret_data}"
server:
  service:
    type: LoadBalancer
EOT
  ]
}

# ------------------------------
# Outputs
# ------------------------------
# Hardcode namespace here instead of referencing helm_release to avoid cycles
output "argocd_namespace" {
  description = "Namespace where ArgoCD is deployed"
  value       = "argocd"
}

