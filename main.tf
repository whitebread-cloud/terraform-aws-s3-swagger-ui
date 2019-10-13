data "external" "swagger_ui_latest_version" {
  program = ["bash", "${path.module}/scripts/latest-version.sh"]
}

locals {
  swagger_ui                                = "swagger-ui"
  swagger_ui_custom_specification_file_name = "api.yml"
  swagger_ui_version                        = "${var.swagger_ui_version != "latest" ? var.swagger_ui_version : lookup(data.external.swagger_ui_latest_version.result, "version")}"
}

data "template_file" "swagger" {
  template = "${file("${path.module}/templates/swagger-ui-s3.sh.tpl")}"
  vars = {
    path                       = path.module
    acl                        = var.s3_acl
    bucket                     = var.s3_bucket
    openapi_specification_path = var.openapi_specification_path
    profile                    = var.profile
    version                    = local.swagger_ui_version
  }
}

resource "null_resource" "swagger" {
  triggers = {
    rendered_template = data.template_file.swagger.rendered
    version           = local.swagger_ui_version
  }

  provisioner "local-exec" {
    command     = data.template_file.swagger.rendered
    interpreter = var.interpreter
  }
}
