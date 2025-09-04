env        = "development"
project_id = "copper-poet-468323-t7"

db_password_secret     = "development-db-password"
argocd_password_secret = "development-argocd-password"

node_disk_type    = "pd-standard"
node_disk_size_gb = 30

service_repos = {
  node-service     = "https://github.com/nolet7/node-service"
  payment-service  = "https://github.com/nolet7/payment-service"
  frontend-service = "https://github.com/nolet7/frontend-service"
}

