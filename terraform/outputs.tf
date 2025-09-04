# ------------------------------
# GKE
# ------------------------------
output "gke_cluster_name" {
  description = "Name of the GKE cluster"
  value       = module.gke.gke_cluster_name
}

# ------------------------------
# Artifact Registry
# ------------------------------
output "artifact_registry_repo" {
  description = "Artifact Registry repository ID"
  value       = module.artifact_registry.artifact_registry_repo
}

# ------------------------------
# Cloud SQL
# ------------------------------
output "cloud_sql_instance" {
  description = "Cloud SQL instance connection name"
  value       = module.cloud_sql.cloud_sql_instance
}

# ------------------------------
# Argo CD
# ------------------------------
output "argocd_namespace" {
  description = "Namespace where ArgoCD is deployed"
  value       = "argocd" # ✅ hardcoded to avoid cycle
}

# Fetch ArgoCD server Service (after Helm install)
data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }

  depends_on = [module.argocd] # ✅ wait for ArgoCD Helm release to exist
}

output "argocd_server_endpoint" {
  description = "External ArgoCD server endpoint (LoadBalancer IP/hostname)"
  value = (
    length(lookup(data.kubernetes_service.argocd_server.status[0], "load_balancer", [])) > 0 ?
    (lookup(data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0], "ip", "") != "" ?
      data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].ip :
      data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname
    ) :
    "pending"
  )
}

# ------------------------------
# Argo CD Applications
# ------------------------------
output "argocd_applications" {
  description = "Rendered YAML manifests for ArgoCD Applications"
  value       = [for app in module.argocd_apps : app]
}

