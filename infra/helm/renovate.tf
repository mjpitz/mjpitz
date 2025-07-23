variable "renovate_token_gitea" {
  type      = string
  sensitive = true
}

variable "renovate_github_token_gitea" {
  type      = string
  sensitive = true
}

variable "renovate_token_c8labs" {
  type      = string
  sensitive = true
}

data "external" "renovate" {
  program = ["./scripts/hash.sh", "./renovate"]
}

resource "helm_release" "renovate" {
  depends_on = [
  ]

  chart     = "./renovate"
  namespace = "vcs"
  name      = "renovate"

  values = [
    file("./renovate/values.yaml"),
  ]

  set_sensitive {
    name  = "gitea.config.token"
    value = var.renovate_token_gitea
  }

  set_sensitive {
    name  = "gitea.github.token"
    value = var.renovate_github_token_gitea
  }

  set_sensitive {
    name  = "c8labs.config.token"
    value = var.renovate_token_c8labs
  }

  set {
    name  = "global.terraform.hash"
    value = data.external.renovate.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}
