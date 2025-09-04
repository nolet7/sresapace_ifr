data "google_secret_manager_secret_version" "db_password" {
  secret  = "${var.env}-db-password"
  project = var.project_id
}

data "google_secret_manager_secret_version" "argocd_password" {
  secret  = "${var.env}-argocd-password"
  project = var.project_id
}

module "gke" {
  source       = "./modules/gke"
  env          = var.env
  region       = var.region
  machine_type = var.machine_type
  node_count   = var.node_count
}

module "artifact_registry" {
  source = "./modules/artifact-registry"
  env    = var.env
  region = var.region
}

module "cloud_sql" {
  source      = "./modules/cloud-sql"
  env         = var.env
  region      = var.region
  db_tier     = var.db_tier
  db_password = data.google_secret_manager_secret_version.db_password.secret_data
}

module "argocd" {
  source         = "./modules/argocd"
  env            = var.env
  admin_password = data.google_secret_manager_secret_version.argocd_password.secret_data
}

# Argo CD Applications for each service repo
module "argocd_apps" {
  source                = "./modules/argocd-app"
  for_each              = toset(var.service_repos)
  app_name              = replace(basename(each.value), "_", "-")
  repo_url              = each.value
  argocd_namespace      = "argocd"
  destination_namespace = "default"
}
