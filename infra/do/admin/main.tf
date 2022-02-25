terraform {
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    region                      = "us-east-1"
    bucket                      = "mya-tfstate"
    key                         = "infra/do/admin/terraform.tfstate"
  }
}

resource "digitalocean_spaces_bucket" "tfstate" {
  name   = "mya-tfstate"
  region = "nyc3"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = 14
    }

    noncurrent_version_expiration {
      days = 7
    }
  }
}

resource "digitalocean_project" "mya" {
  name = "mya"
}

resource "digitalocean_project_resources" "resource_allocation" {
  project   = digitalocean_project.mya.id
  resources = [
    digitalocean_spaces_bucket.tfstate.urn,
  ]
}
