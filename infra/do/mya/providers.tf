terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  # DIGITALOCEAN_TOKEN
  # DIGITALOCEAN_ACCESS_TOKEN
  # SPACES_ACCESS_KEY_ID
  # SPACES_SECRET_ACCESS_KEY
  # DIGITALOCEAN_API_URL
  # SPACES_ENDPOINT_URL
}
