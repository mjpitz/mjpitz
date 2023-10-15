variable "renovate_token" {
  type      = string
  sensitive = true
}

variable "renovate_github_token" {
  type      = string
  sensitive = true
}

data "external" "renovate" {
  program = ["./scripts/hash.sh", "./renovate"]
}

resource "helm_release" "renovate" {
  depends_on = [
    helm_release.gitea,
  ]

  chart     = "./renovate"
  namespace = "vcs"
  name      = "renovate"

  values = [
    file("./renovate/values.yaml"),
  ]

  set_sensitive {
    name  = "renovate.config.token"
    value = var.renovate_token
  }

  set_sensitive {
    name  = "renovate.github.token"
    value = var.renovate_github_token
  }

  set {
    name  = "global.terraform.hash"
    value = data.external.renovate.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}
