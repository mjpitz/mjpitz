variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "pages_admin_username" {
  type      = string
  sensitive = true
}

variable "pages_admin_password" {
  type      = string
  sensitive = true
}

variable "grafana_gitea_client_id" {
  type      = string
  sensitive = true
}

variable "grafana_gitea_client_secret" {
  type      = string
  sensitive = true
}

variable "litestream_access_key_id" {
  type      = string
  sensitive = true
}

variable "litestream_secret_access_key" {
  type      = string
  sensitive = true
}

variable "gitea_security_secret_key" {
  type      = string
  sensitive = true
}

variable "gitea_security_internal_token" {
  type      = string
  sensitive = true
}

variable "gitea_email_username" {
  type      = string
  sensitive = true
}

variable "gitea_email_password" {
  type      = string
  sensitive = true
}

variable "gitea_blobs_access_key_id" {
  type      = string
  sensitive = true
}

variable "gitea_blobs_secret_access_key" {
  type      = string
  sensitive = true
}

variable "registry_http_secret" {
  type      = string
  sensitive = true
}

variable "registry_storage_s3_accesskey" {
  type      = string
  sensitive = true
}

variable "registry_storage_s3_secretkey" {
  type      = string
  sensitive = true
}

variable "registry_ui_password" {
  type      = string
  sensitive = true
}

variable "registry_auth_token_cert" {
  type      = string
  sensitive = true
}

variable "registry_auth_token_key" {
  type      = string
  sensitive = true
}
