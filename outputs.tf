output "openapi_spec_s3_dest_path" {
  value       = var.openapi_spec_s3_dest_path
  description = "The s3 path to the openapi specification"
}

output "openapi_spec_url" {
  value = "${local.openapi_spec_url}"
  description = "The url to the openapi specification"
}

output "swagger_ui_version" {
  value       = local.swagger_ui_version
  description = "The swagger ui version being used"
}
