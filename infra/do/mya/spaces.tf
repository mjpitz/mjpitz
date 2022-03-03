resource "digitalocean_spaces_bucket" "spaces" {
  count = length(var.spaces)

  name = var.spaces[count.index].name
  region = var.spaces[count.index].region
  acl = var.spaces[count.index].acl
}

locals {
  spaces = {for space in digitalocean_spaces_bucket.spaces : space.name => space.bucket_domain_name}
}

resource "digitalocean_cdn" "cdn" {
  count = length(var.cdn)

  origin = local.spaces[var.cdn[count.index].space]
}
