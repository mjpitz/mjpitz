data "external" "gitea" {
  program = ["./scripts/hash.sh", "./gitea"]
}

resource "helm_release" "gitea" {
  depends_on = [
    helm_release.ingress_nginx,
  ]

  chart     = "./gitea"
  namespace = "vcs"
  name      = "gitea"

  values = [
    file("./gitea/values.yaml"),
  ]

  set_sensitive {
    name  = "gitea.config.security.secretKey"
    value = var.gitea_security_secret_key
  }

  set_sensitive {
    name  = "gitea.config.security.internalToken"
    value = var.gitea_security_internal_token
  }

  set_sensitive {
    name  = "gitea.config.email.username"
    value = var.gitea_email_username
  }

  set_sensitive {
    name  = "gitea.config.email.password"
    value = var.gitea_email_password
  }

  set_sensitive {
    name  = "gitea.config.blobs.accessKeyId"
    value = var.gitea_blobs_access_key_id
  }

  set_sensitive {
    name  = "gitea.config.blobs.secretAccessKey"
    value = var.gitea_blobs_secret_access_key
  }

  set_sensitive {
    name  = "gitea.litestream.config.accessKeyId"
    value = var.litestream_access_key_id
  }

  set_sensitive {
    name  = "gitea.litestream.config.secretAccessKey"
    value = var.litestream_secret_access_key
  }

  set {
    name  = "gobal.terraform.hash"
    value = data.external.gitea.result.sha256
  }

  dependency_update = true
  create_namespace  = true

  # don't do these here
  atomic = false
  wait   = false
}
