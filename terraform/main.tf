terraform {
  required_version = ">= 1.6.0"

  backend "gcs" {
    bucket = "srespace-tf-state"
    prefix = "infra"
  }
}

# ------------------------------
# GKE Cluster
# ------------------------------
module "gke" {
  source     = "./modules/gke"
  project_id = var.project_id
  region     = var.region
  env        = var.env
  node_disk_type    = var.node_disk_type
  node_disk_size_gb = var.node_disk_size_gb
}

# ------------------------------
# Artifact Registry
# ------------------------------
module "artifact_registry" {
  source     = "./modules/artifact-registry"
  project_id = var.project_id
  region     = var.region
  env        = var.env
}

# ------------------------------
# Cloud SQL
# ------------------------------
module "cloud_sql" {
  source             = "./modules/cloud-sql"
  project_id         = var.project_id
  region             = var.region
  env                = var.env
  db_password_secret = var.db_password_secret
}

# ------------------------------
# Argo CD (Helm)
# ------------------------------
module "argocd" {
  source                 = "./modules/argocd"
  project_id             = var.project_id
  region                 = var.region
  env                    = var.env
  argocd_password_secret = var.argocd_password_secret
}

# ------------------------------
# Argo CD Applications
# ------------------------------
module "argocd_apps" {
  source   = "./modules/argocd-app"
  for_each = toset(keys(var.service_repos))

  app_name              = each.key
  repo_url              = var.service_repos[each.key]
  env                   = var.env
  argocd_namespace      = "argocd"
  destination_namespace = "default"

  # ✅ enforce dependency on ArgoCD Helm release
  depends_on = [module.argocd]
}

