variable "pages_admin_username" {
  type      = string
  sensitive = true
}

variable "pages_admin_password" {
  type      = string
  sensitive = true
}

data "external" "pages" {
  program = ["./scripts/hash.sh", "./pages"]
}

resource "helm_release" "pages" {
  depends_on = [
    helm_release.ingress_nginx,
  ]

  chart     = "./pages"
  namespace = "pages"
  name      = "pages"

  values = [
    file("./pages/values.yaml"),
  ]

  set_sensitive {
    name  = "pages.config.admin.username"
    value = var.pages_admin_username
  }

  set_sensitive {
    name  = "pages.config.admin.password"
    value = var.pages_admin_password
  }

  set {
    name  = "global.terraform.hash"
    value = data.external.pages.result.sha256
  }

  set {
    name  = "12factor.deployment.annotations.terraform\\.io/hash"
    value = data.external.pages.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
  wait              = true
}
