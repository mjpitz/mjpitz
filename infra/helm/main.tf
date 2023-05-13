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

data "external" "kube_prometheus_stack" {
  program = ["./scripts/hash.sh", "./kube-prometheus-stack"]
}

data "external" "kube_prometheus_stack_secrets" {
  program = ["helm", "secrets", "decrypt", "--terraform", "./kube-prometheus-stack/values-secret.yaml"]
}

resource "helm_release" "kube_prometheus_stack" {
  chart     = "./kube-prometheus-stack"
  namespace = "monitoring"
  name      = "kube-prometheus-stack"

  values = [
    file("./kube-prometheus-stack/values.yaml"),
    base64decode(data.external.kube_prometheus_stack_secrets.result.content_base64),
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

data "external" "cert_manager_secrets" {
  program = ["helm", "secrets", "decrypt", "--terraform", "./cert-manager/values-secret.yaml"]
}

resource "helm_release" "cert_manager" {
  depends_on = [
    helm_release.kube_prometheus_stack,
  ]

  chart     = "./cert-manager"
  namespace = "cert-manager"
  name      = "cert-manager"

  values = [
    file("./cert-manager/values.yaml"),
    base64decode(data.external.cert_manager_secrets.result.content_base64),
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

data "external" "external_dns_secrets" {
  program = ["helm", "secrets", "decrypt", "--terraform", "./external-dns/values-secret.yaml"]
}

resource "helm_release" "external_dns" {
  depends_on = [
    helm_release.kube_prometheus_stack,
  ]

  chart     = "./external-dns"
  namespace = "ingress"
  name      = "external-dns"

  values = [
    file("./external-dns/values.yaml"),
    base64decode(data.external.external_dns_secrets.result.content_base64),
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

data "external" "registry_secrets" {
  program = ["helm", "secrets", "decrypt", "--terraform", "./registry/values-secret.yaml"]
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
    base64decode(data.external.registry_secrets.result.content_base64),
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
    value = data.external.dist.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}

data "external" "maddy" {
  program = ["./scripts/hash.sh", "./maddy"]
}

data "external" "maddy_secrets" {
  program = ["helm", "secrets", "decrypt", "--terraform", "./maddy/values-secret.yaml"]
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
    base64decode(data.external.maddy_secrets.result.content_base64),
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

data "external" "gitea_secrets" {
  program = ["helm", "secrets", "decrypt", "--terraform", "./gitea/values-secret.yaml"]
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
    base64decode(data.external.gitea_secrets.result.content_base64),
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

data "external" "drone_secrets" {
  program = ["helm", "secrets", "decrypt", "--terraform", "./drone/values-secret.yaml"]
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
    base64decode(data.external.drone_secrets.result.content_base64),
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

data "external" "pages" {
  program = ["./scripts/hash.sh", "./pages"]
}

data "external" "pages_secrets" {
  program = ["helm", "secrets", "decrypt", "--terraform", "./pages/values-secret.yaml"]
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
    base64decode(data.external.pages_secrets.result.content_base64),
  ]

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
