terraform {
  required_version = ">= 1.6.0"

  backend "gcs" {
    bucket = "srespace-tf-state"
    prefix = "infra"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" {
  config_path = "~/.kube/config"
}

provider "local" {}

# ------------------------------
# GKE Cluster
# ------------------------------
module "gke" {
  source     = "./modules/gke"
  project_id = var.project_id
  region     = var.region
  env        = var.env
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
  source     = "./modules/cloud-sql"
  project_id = var.project_id
  region     = var.region
  env        = var.env
}

# ------------------------------
# Argo CD (Helm)
# ------------------------------
module "argocd" {
  source     = "./modules/argocd"
  project_id = var.project_id
  region     = var.region
  env        = var.env
}

# ------------------------------
# Argo CD Applications (Backstage services)
# ------------------------------
module "argocd_apps" {
  source     = "./modules/argocd-app"
  for_each   = toset(var.service_repos)

  app_name              = each.key
  repo_url              = each.value
  env                   = var.env
  argocd_namespace      = "argocd"
  destination_namespace = "default"
}

