data "external" "external_dns" {
  program = ["./scripts/hash.sh", "./external-dns"]
}

resource "helm_release" "external_dns" {
  chart     = "./external-dns"
  namespace = "ingress"
  name      = "external-dns"

  values = [
    file("./external-dns/values.yaml"),
  ]

  set_sensitive {
    name  = "cloudflare.apiToken"
    value = var.cloudflare_api_token
  }

  set {
    name  = "global.terraform.hash"
    value = data.external.external_dns.result.sha256
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}
