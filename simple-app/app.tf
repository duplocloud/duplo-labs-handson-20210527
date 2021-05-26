// STEP 7 - Create and configure a application that can use the AWS services.
resource "duplocloud_duplo_service" "myapp" {
  depends_on = [ duplocloud_aws_host.eks ] // wait for the node to be available

  tenant_id = duplocloud_tenant.this.tenant_id

  name           = "myapp"
  agent_platform = 7 # Duplo EKS agent
  docker_image   = "nginx:latest"
  replicas       = 1

  other_docker_config = jsonencode({
    // Example:  using environment variables to pass information to the application.
    Env = [
      // S3 bucket configuration
      { Name = "S3_BUCKET_NAME",    Value = duplocloud_s3_bucket.mydata.fullname },

      // Redis configuration
      { Name = "REDIS_ENDPOINT",    Value = duplocloud_ecache_instance.mycache.endpoint },

      // Database configuration
      { Name = "POSTGRES_ENDPOINT", Value = duplocloud_rds_instance.this.endpoint },
      { Name = "POSTGRES_USER",     Value = duplocloud_rds_instance.this.master_username },
      { Name = "POSTGRES_PASSWORD", Value = duplocloud_rds_instance.this.master_password }
    ]
  })
}

// STEP 8 - Securely expose the application behind a load balancer fronted by a web application firewall.
resource "duplocloud_duplo_service_lbconfigs" "myapp" {
  tenant_id                   = duplocloud_duplo_service.myapp.tenant_id
  replication_controller_name = duplocloud_duplo_service.myapp.name

  lbconfigs {
    external_port    = 80 // 443
    health_check_url = "/"
    is_native        = false
    lb_type          = 1 # Application load balancer
    port             = "80"
    protocol         = "http"
    // certificate_arn  = data.terraform_remote_state.base-infra.outputs["acm_certificate_arn"]
  }
}
resource "duplocloud_duplo_service_params" "myapp" {
  tenant_id = duplocloud_duplo_service_lbconfigs.myapp.tenant_id

  replication_controller_name = duplocloud_duplo_service_lbconfigs.myapp.replication_controller_name
  dns_prfx                    = "myapp"
  drop_invalid_headers        = true
  enable_access_logs          = true

  // webaclid = data.terraform_remote_state.base-infra.outputs["webaclid"]
}
