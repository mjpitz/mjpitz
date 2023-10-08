variable "grafana_gitea_client_id" {
  type      = string
  sensitive = true
}

variable "grafana_gitea_client_secret" {
  type      = string
  sensitive = true
}

data "external" "kube_prometheus_stack" {
  program = ["./scripts/hash.sh", "./kube-prometheus-stack"]
}

resource "helm_release" "kube_prometheus_stack" {
  chart     = "./kube-prometheus-stack"
  namespace = "monitoring"
  name      = "kube-prometheus-stack"

  values = [
    file("./kube-prometheus-stack/values.yaml"),
  ]

  set_sensitive {
    name  = "grafana.giteaClientId"
    value = var.grafana_gitea_client_id
  }

  set_sensitive {
    name  = "grafana.giteaClientSecret"
    value = var.grafana_gitea_client_secret
  }

  set {
    name  = "global.terraform.hash"
    value = data.external.kube_prometheus_stack.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}
