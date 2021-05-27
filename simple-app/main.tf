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

// STEP 3 - Retrieve information about the base infrastructure that was previous created.
data "duplocloud_aws_account" "this" {}
data "duplocloud_admin_aws_credentials" "this" {}
data "terraform_remote_state" "base-infra" {
  backend = "s3"

  config = {
    region     = "us-west-2" # bucket region
    bucket     = "duplo-tfstate-${data.duplocloud_aws_account.this.account_id}"
    key        = "infra:/lab/base-infra"
    access_key = data.duplocloud_admin_aws_credentials.this.access_key_id
    secret_key = data.duplocloud_admin_aws_credentials.this.secret_access_key
    token      = data.duplocloud_admin_aws_credentials.this.session_token
  }
}

// STEP 4 - Create tenant for the lab session.
resource "duplocloud_tenant" "this" {
  account_name = "lab"
  plan_id      = data.terraform_remote_state.base-infra.outputs["plan_id"]
}


// STEP 5 - Create an EKS node in the tenant.
resource "duplocloud_aws_host" "eks" {
  tenant_id     = duplocloud_tenant.this.tenant_id
  friendly_name = "eks1"

  image_id       = data.terraform_remote_state.base-infra.outputs["eks_node_ami"]
  capacity       = "t3a.medium"
  agent_platform = 7          # Duplo EKS agent
  zone           = 0          # Zone A
  user_account   = duplocloud_tenant.this.account_name
}
