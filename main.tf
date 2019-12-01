data "external" "swagger_ui_latest_version" {
  program = ["bash", "${path.module}/scripts/latest-version.sh"]
}

locals {
  openapi_spec_s3_dest_path = "s3://${var.s3_bucket_path}/${basename(var.openapi_spec_path)}"
  openapi_spec_url          = "${var.openapi_spec_url != "" ? var.openapi_spec_url : basename(var.openapi_spec_path)}"
  swagger_ui_version        = "${var.swagger_ui_version != "latest" ? var.swagger_ui_version : lookup(data.external.swagger_ui_latest_version.result, "version")}"
}

data "template_file" "swagger" {
  template = "${file("${path.module}/templates/swagger-ui-s3.sh.tpl")}"
  vars = {
    path                      = path.module
    acl                       = var.s3_acl
    bucket_path               = var.s3_bucket_path
    openapi_spec_path         = var.openapi_spec_path
    openapi_spec_s3_dest_path = local.openapi_spec_s3_dest_path
    openapi_spec_url          = local.openapi_spec_url
    swagger_ui_version        = local.swagger_ui_version
    profile                   = var.profile
  }
}

resource "null_resource" "swagger" {
  triggers = {
    rendered_template  = data.template_file.swagger.rendered
    swagger_ui_version = local.swagger_ui_version
    openapi_spec_path  = "${sha1(file(var.openapi_spec_path))}"
  }

  provisioner "local-exec" {
    command     = data.template_file.swagger.rendered
    interpreter = var.interpreter
  }
}
