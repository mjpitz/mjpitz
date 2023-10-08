variable "registry_http_secret" {
  type      = string
  sensitive = true
}

variable "registry_storage_s3_accesskey" {
  type      = string
  sensitive = true
}

variable "registry_storage_s3_secretkey" {
  type      = string
  sensitive = true
}

variable "registry_ui_password" {
  type      = string
  sensitive = true
}

variable "registry_auth_token_cert" {
  type      = string
  sensitive = true
}

variable "registry_auth_token_key" {
  type      = string
  sensitive = true
}

data "external" "registry" {
  program = ["./scripts/hash.sh", "./registry"]
}

resource "helm_release" "registry" {
  depends_on = [
    helm_release.ingress_nginx,
  ]

  chart     = "./registry"
  namespace = "registry"
  name      = "registry"

  values = [
    file("./registry/values.yaml"),
  ]

  set_sensitive {
    name  = "registry.config.http.secret"
    value = var.registry_http_secret
  }

  set_sensitive {
    name  = "registry.config.storage.s3.accesskey"
    value = var.registry_storage_s3_accesskey
  }

  set_sensitive {
    name  = "registry.config.storage.s3.secretkey"
    value = var.registry_storage_s3_secretkey
  }

  set_sensitive {
    name  = "registry.ui.config.auth.token.password"
    value = var.registry_ui_password
  }

  set_sensitive {
    name  = "registry.auth.token.cert"
    value = var.registry_auth_token_cert
  }

  set_sensitive {
    name  = "registry.auth.token.key"
    value = var.registry_auth_token_key
  }

  set {
    name  = "global.terraform.hash"
    value = data.external.registry.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}
