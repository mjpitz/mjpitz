terraform {
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    region                      = "us-east-1"
    bucket                      = "mya-tfstate"
    key                         = "infra/helm/terraform.tfstate"
  }
}

resource "helm_release" "sealed_secrets" {
  chart     = "./sealed-secrets"
  namespace = "kube-system"
  name      = "sealed-secrets"

  values = [
    file("./sealed-secrets/values.yaml"),
  ]

  dependency_update = true
  create_namespace  = true
  atomic            = true
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

  dependency_update = true
  create_namespace  = true
  atomic            = true
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

  dependency_update = true
  create_namespace  = true
  atomic            = true
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

  dependency_update = true
  create_namespace  = true
  atomic            = true
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

  dependency_update = true
  create_namespace  = true

  # don't do these here
  atomic = false
  wait   = false
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

  dependency_update = true
  create_namespace  = true
  atomic            = true
}

resource "helm_release" "storj_registry" {
  depends_on = [
    helm_release.ingress_nginx,
  ]

  chart     = "./storj-registry"
  namespace = "storj-registry"
  name      = "storj-registry"

  values = [
    file("./storj-registry/values.yaml"),
    file("./storj-registry/secret.yaml"),
  ]

  dependency_update = true
  create_namespace  = true
  atomic            = true
}
