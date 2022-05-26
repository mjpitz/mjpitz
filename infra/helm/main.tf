terraform {
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    region                      = "us-east-1"
    bucket                      = "mya-terraform"
    key                         = "infra/helm/terraform.terraform"
  }
}

data "external" "sealed_secrets" {
  program = ["./scripts/hash.sh", "./sealed-secrets"]
}

resource "helm_release" "sealed_secrets" {
  chart     = "./sealed-secrets"
  namespace = "kube-system"
  name      = "sealed-secrets"

  values = [
    file("./sealed-secrets/values.yaml"),
  ]

  set {
    name  = "global.terraform.hash"
    value = data.external.sealed_secrets.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}

data "external" "kube_prometheus_stack" {
  program = ["./scripts/hash.sh", "./kube-prometheus-stack"]
}

resource "helm_release" "kube_prometheus_stack" {
  depends_on = [
    helm_release.sealed_secrets,
  ]

  chart     = "./kube-prometheus-stack"
  namespace = "monitoring"
  name      = "kube-prometheus-stack"

  values = [
    file("./kube-prometheus-stack/values.yaml"),
  ]

  set {
    name  = "global.terraform.hash"
    value = data.external.kube_prometheus_stack.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}

data "external" "cert_manager" {
  program = ["./scripts/hash.sh", "./cert-manager"]
}

resource "helm_release" "cert_manager" {
  depends_on = [
    helm_release.sealed_secrets,
    helm_release.kube_prometheus_stack,
  ]

  chart     = "./cert-manager"
  namespace = "cert-manager"
  name      = "cert-manager"

  values = [
    file("./cert-manager/values.yaml"),
  ]

  set {
    name  = "global.terraform.hash"
    value = data.external.cert_manager.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}

data "external" "external_dns" {
  program = ["./scripts/hash.sh", "./external-dns"]
}

resource "helm_release" "external_dns" {
  depends_on = [
    helm_release.sealed_secrets,
    helm_release.kube_prometheus_stack,
  ]

  chart     = "./external-dns"
  namespace = "ingress"
  name      = "external-dns"

  values = [
    file("./external-dns/values.yaml"),
  ]

  set {
    name  = "global.terraform.hash"
    value = data.external.external_dns.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}

data "external" "ingress_nginx" {
  program = ["./scripts/hash.sh", "./ingress-nginx"]
}

resource "helm_release" "ingress_nginx" {
  depends_on = [
    helm_release.sealed_secrets,
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
    file("./registry/secret.yaml"),
  ]

  set {
    name  = "global.terraform.hash"
    value = data.external.registry.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}

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
    value = data.external.sealed_secrets.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}

data "external" "maddy" {
  program = ["./scripts/hash.sh", "./maddy"]
}

resource "helm_release" "maddy" {
  depends_on = [
    helm_release.kube_prometheus_stack,
    helm_release.cert_manager,
    helm_release.external_dns,
  ]

  chart     = "./maddy"
  namespace = "email"
  name      = "maddy"

  values = [
    file("./maddy/values.yaml"),
    file("./maddy/secret.yaml"),
  ]

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
    file("./gitea/secret.yaml"),
  ]

  set {
    name  = "global.terraform.hash"
    value = data.external.gitea.result.sha256
  }

  dependency_update = true
  create_namespace  = true

  # don't do these here
  atomic = false
  wait   = false
}

data "external" "drone" {
  program = ["./scripts/hash.sh", "./drone"]
}

resource "helm_release" "drone" {
  depends_on = [
    helm_release.ingress_nginx,
    helm_release.gitea,
  ]

  chart     = "./drone"
  namespace = "cicd"
  name      = "drone"

  values = [
    file("./drone/values.yaml"),
    file("./drone/secret.yaml"),
  ]

  set {
    name  = "global.terraform.hash"
    value = data.external.drone.result.sha256
  }

  dependency_update = true
  create_namespace  = true

  # don't do these here
  atomic = false
  wait   = false
}

data "external" "catalog" {
  program = ["./scripts/hash.sh", "./catalog"]
}

resource "helm_release" "catalog" {
  depends_on = [
    helm_release.ingress_nginx,
  ]

  chart     = "./catalog"
  namespace = "catalog"
  name      = "catalog"

  values = [
    file("./catalog/values.yaml"),
  ]

  set {
    name  = "global.terraform.hash"
    value = data.external.catalog.result.sha256
  }

  set {
    name = "12factor.deployment.annotations.terraform\\.io/hash"
    value = data.external.catalog.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic = true
  wait   = true
}
