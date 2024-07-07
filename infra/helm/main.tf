terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://nyc3.digitaloceanspaces.com"
    }
    region                      = "us-east-1"
    bucket                      = "mya-terraform"
    key                         = "infra/helm/terraform.terraform"
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}
