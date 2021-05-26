// STEP 6 - Create and harden multiple AWS managed services that the application will use:
//
//   - an AWS ElasticCache Redis instance
//   - an AWS S3 bucket
//   - an AWS RDS instance (with a randomly generated password)
//

resource "duplocloud_ecache_instance" "mycache" {
  tenant_id  = duplocloud_tenant.this.tenant_id
  name       = "mycache"
  cache_type = 0 // Redis
  replicas   = 1
  size       = "cache.t2.small"
}

resource "duplocloud_s3_bucket" "mydata" {
  tenant_id = duplocloud_tenant.this.tenant_id
  name      = "mydata"

  allow_public_access = false
  enable_access_logs  = true
  enable_versioning   = true
  managed_policies    = ["ssl"]
  default_encryption {
    method = "Sse"
  }
}

resource "duplocloud_rds_instance" "this" {
  tenant_id      = duplocloud_tenant.this.tenant_id
  name           = "psql"
  engine         = 1 // PostgreSQL
  engine_version = "12.5"
  size           = "db.t3.medium"

  master_username = "lab"
  master_password = random_password.mypassword.result

  encrypt_storage = true
}

resource "random_password" "mypassword" {
  length  = 16
  number  = true
  special = false
}
