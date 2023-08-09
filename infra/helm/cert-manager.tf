data "external" "cert_manager" {
  program = ["./scripts/hash.sh", "./cert-manager"]
}

resource "helm_release" "cert_manager" {
  depends_on = [
    helm_release.kube_prometheus_stack,
  ]

  chart     = "./cert-manager"
  namespace = "cert-manager"
  name      = "cert-manager"

  values = [
    file("./cert-manager/values.yaml"),
  ]

  set_sensitive {
    name  = "cloudflare.apiToken"
    value = var.cloudflare_api_token
  }

  set {
    name  = "global.terraform.hash"
    value = data.external.cert_manager.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}
