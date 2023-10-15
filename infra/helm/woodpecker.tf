variable "woodpecker_gitea_client_id" {
  type      = string
  sensitive = true
}

variable "woodpecker_gitea_client_secret" {
  type      = string
  sensitive = true
}

variable "woodpecker_agent_secret" {
  type      = string
  sensitive = true
}

variable "woodpecker_encryption_key" {
  type      = string
  sensitive = true
}

data "external" "woodpecker" {
  program = ["./scripts/hash.sh", "./woodpecker"]
}

resource "helm_release" "woodpecker" {
  depends_on = [
    helm_release.gitea,
  ]

  chart     = "./woodpecker"
  namespace = "vcs"
  name      = "woodpecker"

  values = [
    file("./woodpecker/values.yaml"),
  ]

  set_sensitive {
    name  = "woodpecker.server.secret.WOODPECKER_GITEA_CLIENT"
    value = var.woodpecker_gitea_client_id
  }

  set_sensitive {
    name  = "woodpecker.server.secret.WOODPECKER_GITEA_SECRET"
    value = var.woodpecker_gitea_client_secret
  }

  set_sensitive {
    name  = "woodpecker.agent.secret.WOODPECKER_AGENT_SECRET"
    value = var.woodpecker_agent_secret
  }

  set_sensitive {
    name  = "woodpecker.server.secret.WOODPECKER_AGENT_SECRET"
    value = var.woodpecker_agent_secret
  }

  set_sensitive {
    name  = "woodpecker.server.secret.WOODPECKER_ENCRYPTION_KEY"
    value = var.woodpecker_encryption_key
  }

  set {
    name  = "global.terraform.hash"
    value = data.external.woodpecker.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}
