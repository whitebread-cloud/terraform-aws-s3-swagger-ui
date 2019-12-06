data "external" "swagger_ui_latest_version" {
  program = ["bash", "${path.module}/scripts/latest-version.sh"]
}

locals {
  openapi_spec_url   = "${var.openapi_spec_url != "" ? var.openapi_spec_url : var.openapi_spec_paths != [] ? basename(var.openapi_spec_paths) : ""}"
  swagger_ui_version = "${var.swagger_ui_version != "latest" ? var.swagger_ui_version : lookup(data.external.swagger_ui_latest_version.result, "version")}"
}

data "template_file" "install_swagger_ui" {
  template = "${file("${path.module}/templates/swagger-ui-s3.sh.tpl")}"
  vars = {
    path               = path.module
    acl                = var.s3_acl
    bucket_path        = var.s3_bucket_path
    openapi_spec_paths = "( %{for path in var.openapi_spec_paths~} \"${path}\" %{endfor~})"
    openapi_spec_url   = local.openapi_spec_url
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
    #openapi_spec_sha   = "${var.openapi_spec_paths != [] ? sha1(file(var.openapi_spec_paths)) : ""}"
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
