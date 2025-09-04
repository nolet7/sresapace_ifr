# SRESpace Infrastructure Repo

This repository manages the infrastructure for the Internal Developer Platform (IDP) using Terraform.

## Components
- GKE (Google Kubernetes Engine) cluster
- Cloud SQL (Postgres) for Backstage
- Artifact Registry for container images
- Cloud Build for CI/CD
- Argo CD for GitOps
- Service auto-registration via Backstage + Terraform

## Workflow
1. Backstage scaffolds a new service repo.
2. Webhook triggers GitHub Actions in this repo.
3. Terraform applies an Argo CD Application CRD for the new repo.
4. Argo CD syncs → service is deployed to GKE.

