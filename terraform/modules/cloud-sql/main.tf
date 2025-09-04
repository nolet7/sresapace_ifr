variable "project_id" {}
variable "region" {}
variable "env" {}
variable "db_password_secret" {
  description = "Secret Manager ID for the DB password"
}
variable "db_password" {
  description = "Initial DB password (used only if secret is missing)"
  default     = null
}

# Ensure secret exists
resource "google_secret_manager_secret" "db_password" {
  project   = var.project_id
  secret_id = var.db_password_secret

  replication {
    auto {}
  }
}

# Add secret version (only if db_password is provided)
resource "google_secret_manager_secret_version" "db_password" {
  count       = var.db_password != null ? 1 : 0
  secret      = google_secret_manager_secret.db_password.id
  secret_data = var.db_password
}

# Fetch latest password (manual rotations still work)
data "google_secret_manager_secret_version" "db_password" {
  project = var.project_id
  secret  = var.db_password_secret
  version = "latest"
}

resource "google_sql_database_instance" "backstage" {
  name             = "${var.env}-backstage-db"
  database_version = "POSTGRES_15"
  region           = var.region
  project          = var.project_id

  settings {
    tier              = "db-f1-micro"
    availability_type = "ZONAL"

    backup_configuration {
      enabled = true
    }
  }
}

resource "google_sql_database" "backstage_db" {
  name     = "backstage"
  instance = google_sql_database_instance.backstage.name
  project  = var.project_id
}

resource "google_sql_user" "backstage_user" {
  name     = "backstage"
  instance = google_sql_database_instance.backstage.name
  project  = var.project_id
  password = data.google_secret_manager_secret_version.db_password.secret_data
}

output "cloud_sql_instance" {
  value = google_sql_database_instance.backstage.connection_name
}

