terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.42.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.16.0"
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

data "digitalocean_kubernetes_cluster" "mya_nyc" {
  name = "mya-nyc"
}

provider "helm" {
  kubernetes {
    host  = data.digitalocean_kubernetes_cluster.mya_nyc.endpoint
    token = data.digitalocean_kubernetes_cluster.mya_nyc.kube_config[0].token
    cluster_ca_certificate = base64decode(
      data.digitalocean_kubernetes_cluster.mya_nyc.kube_config[0].cluster_ca_certificate
    )
  }
}
