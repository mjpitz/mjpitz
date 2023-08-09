data "external" "ingress_nginx" {
  program = ["./scripts/hash.sh", "./ingress-nginx"]
}

resource "helm_release" "ingress_nginx" {
  depends_on = [
    helm_release.kube_prometheus_stack,
    helm_release.cert_manager,
    helm_release.external_dns,
  ]

  chart     = "./ingress-nginx"
  namespace = "ingress"
  name      = "ingress-nginx"

  values = [
    file("./ingress-nginx/values.yaml"),
  ]

  set {
    name  = "global.terraform.hash"
    value = data.external.ingress_nginx.result.sha256
  }

  dependency_update = true
  create_namespace  = true

  # don't do these here
  atomic = false
  wait   = false
}
