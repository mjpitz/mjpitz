terraform {
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    region                      = "us-east-1"
    bucket                      = "mya-terraform"
    key                         = "infra/do/admin/terraform.tfstate"
  }
}

resource "digitalocean_spaces_bucket" "tfstate" {
  name   = "mya-terraform"
  region = "nyc3"
  acl    = "private"

  versioning {
    enabled = true
  }

  # intentionally not expiring here
}

data "digitalocean_project" "mya" {
  name = "mya"
}

resource "digitalocean_project_resources" "resource_allocation" {
  project   = data.digitalocean_project.mya.id
  resources = [
    digitalocean_spaces_bucket.tfstate.urn,
  ]
}
