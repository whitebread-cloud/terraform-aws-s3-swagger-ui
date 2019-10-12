output "swagger_ui_version" {
  value = local.swagger_ui_version
  description = "The swagger ui version being used"
}

output "openapi_specification_path" {
  value = var.openapi_specification_path
  description = "The path to the openapi specification"
}
