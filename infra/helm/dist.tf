data "external" "dist" {
  program = ["./scripts/hash.sh", "./dist"]
}

resource "helm_release" "dist" {
  depends_on = [
    helm_release.ingress_nginx,
  ]

  chart     = "./dist"
  namespace = "dist"
  name      = "dist"

  values = [
    file("./dist/values.yaml"),
  ]

  set {
    name  = "global.terraform.hash"
    value = data.external.dist.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}
