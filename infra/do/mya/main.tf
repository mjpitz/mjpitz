terraform {
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    region                      = "us-east-1"
    bucket                      = "mya-tfstate"
    key                         = "infra/do/mya/terraform.tfstate"
  }
}

data "digitalocean_project" "project" {
  name = var.project
}

resource "digitalocean_project_resources" "resource_allocation" {
  project   = data.digitalocean_project.project.id
  resources = concat(
    digitalocean_kubernetes_cluster.clusters.*.urn,
    digitalocean_spaces_bucket.spaces.*.urn,
  )
}
