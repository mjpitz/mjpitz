data "external" "maddy" {
  program = ["./scripts/hash.sh", "./maddy"]
}

resource "helm_release" "maddy" {
  depends_on = [
    helm_release.cert_manager,
    helm_release.longhorn,
  ]

  chart     = "./maddy"
  namespace = "email"
  name      = "maddy"

  values = [
    file("./maddy/values.yaml"),
  ]

  set_sensitive {
    name  = "maddy.litestream.config.accessKeyId"
    value = var.litestream_access_key_id
  }

  set_sensitive {
    name  = "maddy.litestream.config.secretAccessKey"
    value = var.litestream_secret_access_key
  }

  set {
    name  = "global.terraform.hash"
    value = data.external.maddy.result.sha256
  }

  dependency_update = true
  create_namespace  = true

  # don't do these here
  atomic = false
  wait   = false
}
