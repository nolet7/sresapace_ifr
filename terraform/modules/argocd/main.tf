variable "project_id" {}
variable "region" {}
variable "env" {}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.8"

  create_namespace = true

  values = [<<EOF
configs:
  params:
    server.insecure: true
server:
  service:
    type: LoadBalancer
EOF
  ]
}

output "argocd_namespace" {
  value = helm_release.argocd.namespace
}
<--- paste Argo CD module code here --->
