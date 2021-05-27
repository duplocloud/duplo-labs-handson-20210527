output "app_url" {
  value = "https://${duplocloud_duplo_service_params.myapp.dns_prfx}.${data.terraform_remote_state.base-infra.outputs["infra_name"]}.duplocloud-events.com"
}
