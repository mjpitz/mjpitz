# shared secrets go here

variable "cloudflare_api_token" {
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
