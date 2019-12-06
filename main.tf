data "external" "swagger_ui_latest_version" {
  program = ["bash", "${path.module}/scripts/latest-version.sh"]
}

locals {
  swagger_ui_version = var.swagger_ui_version != "latest" ? var.swagger_ui_version : lookup(data.external.swagger_ui_latest_version.result, "version")
}

data "template_file" "install_swagger_ui" {
  template = "${file("${path.module}/templates/swagger-ui-s3.sh.tpl")}"
  vars = {
    path               = path.module
    acl                = var.s3_acl
    bucket_path        = var.s3_bucket_path
    openapi_spec_paths = "(${join(" ", var.openapi_spec_paths)})"
    openapi_spec_urls  = "(${join(" ", var.openapi_spec_urls)})"
    swagger_ui_version = local.swagger_ui_version
    profile            = var.profile
  }
}

data "template_file" "destroy_swagger_ui" {
  template = "${file("${path.module}/templates/swagger-ui-s3-destroy.sh.tpl")}"
  vars = {
    bucket_path = var.s3_bucket_path
    profile     = var.profile
  }
}

resource "null_resource" "swagger" {
  triggers = {
    rendered_template  = data.template_file.install_swagger_ui.rendered
    swagger_ui_version = local.swagger_ui_version
    openapi_spec_sha = sha1(join(" ", [
      for path in var.openapi_spec_paths :
      file(path)
    ]))
  }

  provisioner "local-exec" {
    command     = data.template_file.install_swagger_ui.rendered
    interpreter = var.interpreter
  }

  provisioner "local-exec" {
    when        = "destroy"
    command     = data.template_file.destroy_swagger_ui.rendered
    interpreter = var.interpreter
  }
}
