variable "gitea_runner_token" {
  type      = string
  sensitive = true
}

data "external" "gitea_runner" {
  program = ["./scripts/hash.sh", "./gitea-runner"]
}

resource "helm_release" "gitea_runner" {
  depends_on = [
    helm_release.gitea,
  ]

  chart     = "./gitea-runner"
  namespace = "vcs"
  name      = "gitea-runner"

  values = [
    file("./gitea/values.yaml"),
  ]

  set_sensitive {
    name  = "runner.deployment.application.env.GITEA_RUNNER_REGISTRATION_TOKEN"
    value = var.gitea_runner_token
  }

  set {
    name  = "gobal.terraform.hash"
    value = data.external.gitea_runner.result.sha256
  }

  set {
    name  = "12factor.deployment.annotations.terraform\\.io/hash"
    value = data.external.gitea_runner.result.sha256
  }

  dependency_update = true
  create_namespace  = true

  # don't do these here
  atomic = false
  wait   = false
}