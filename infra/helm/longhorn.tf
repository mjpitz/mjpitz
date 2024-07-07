data "external" "longhorn" {
  program = ["./scripts/hash.sh", "./longhorn"]
}

resource "helm_release" "longhorn" {
  chart     = "./longhorn"
  namespace = "longhorn-system"
  name      = "longhorn"

  values = [
    file("./longhorn/values.yaml"),
  ]

  dependency_update = true
  create_namespace  = true
  atomic            = true
}
