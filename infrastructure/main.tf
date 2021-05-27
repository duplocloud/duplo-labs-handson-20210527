// STEP 1 - Declare Terraform and provider versions.
terraform {
  required_version = "~> 0.14"
  required_providers {
    duplocloud = {
      version = "~> 0.5.33"
      source  = "duplocloud/duplocloud"
    }
    random = { version = "~> 3.1.0" }
  }
}

// STEP 2 - Configure DuploCloud provider.
provider "duplocloud" {
  # duplo_host = "https://labstest01.duplocloud.net"
  # duplo_token = "xxx"
}

// STEP 3 - Create a new infrastructure in duplo
resource "duplocloud_infrastructure" "this" {
  infra_name        = "labinfra"
  cloud             = 0
  region            = "us-west-2"
  azcount           = 2
  enable_k8_cluster = false
  address_prefix    = "10.123.0.0/16"
  subnet_cidr       = 24

  provisioner "local-exec" {
    when = destroy
    command = "sleep 90"
  }
}
