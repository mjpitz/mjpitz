resource "digitalocean_vpc" "networks" {
  count = length(var.networks)

  name     = var.networks[count.index].name
  region   = var.networks[count.index].region
  ip_range = var.networks[count.index].ip_range
}
