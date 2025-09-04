output "gke_cluster_endpoint" {
  value = module.gke.endpoint
}

output "artifact_registry" {
  value = module.artifact_registry.url
}

output "cloud_sql_connection" {
  value = module.cloud_sql.connection_name
}

output "argocd_server_url" {
  value = module.argocd.server_url
}
