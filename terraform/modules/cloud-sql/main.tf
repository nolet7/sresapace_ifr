variable "project_id" {}
variable "region" {}
variable "env" {}

resource "google_sql_database_instance" "backstage" {
  name             = "${var.env}-backstage-db"
  database_version = "POSTGRES_15"
  region           = var.region
  project          = var.project_id

  settings {
    tier = "db-f1-micro"
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
  password = "changeme123" # ❗ replace with Secret Manager later
  project  = var.project_id
}

output "cloud_sql_instance" {
  value = google_sql_database_instance.backstage.connection_name
}
<--- paste Cloud SQL module code here --->
