terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

variable "app_name" {}
variable "repo_url" {}
variable "argocd_namespace" {
  default = "argocd"
}
variable "destination_namespace" {
  default = "default"
}
variable "env" {
  description = "Deployment environment (development, staging, production)"
}

resource "kubectl_manifest" "argocd_app" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${var.env}-${var.app_name}
  namespace: ${var.argocd_namespace}
spec:
  project: default
  source:
    repoURL: ${var.repo_url}
    targetRevision: main
    path: skeleton/helm
  destination:
    server: https://kubernetes.default.svc
    namespace: ${var.destination_namespace}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
YAML
}

resource "local_file" "argocd_app_yaml" {
  content = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${var.env}-${var.app_name}
  namespace: ${var.argocd_namespace}
spec:
  project: default
  source:
    repoURL: ${var.repo_url}
    targetRevision: main
    path: skeleton/helm
  destination:
    server: https://kubernetes.default.svc
    namespace: ${var.destination_namespace}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
YAML

  filename = "${path.root}/../argocd-apps/${var.env}-${var.app_name}-app.yaml"
}
