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

// STEP 3 - Retrieve information about the tenant that was previously created.
data "duplocloud_tenant" "this" {
  name = "lab"
}

// STEP 4 - Create and harden an AWS Kafka cluster
resource "duplocloud_aws_kafka_cluster" "this" {
  tenant_id     = data.duplocloud_tenant.this.id
  name          = "mycluster"
  kafka_version = "2.4.1.1"
  instance_type = "kafka.m5.large"
  storage_size  = 20
  timeouts {
    create = "45m"
  }
}
