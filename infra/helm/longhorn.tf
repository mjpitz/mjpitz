variable "longhorn_backup_access_key_id" {
  type      = string
  sensitive = true
}

variable "longhorn_backup_secret_access_key" {
  type      = string
  sensitive = true
}

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

  set_sensitive {
    name  = "backup.accessKeyID"
    value = var.longhorn_backup_access_key_id
  }

  set_sensitive {
    name  = "backup.secretAccessKey"
    value = var.longhorn_backup_secret_access_key
  }

  dependency_update = true
  create_namespace  = true
  atomic            = true
}
