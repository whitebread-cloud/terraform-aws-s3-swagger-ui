# terraform-aws-s3-swagger-ui

## Summary

Terraform module for installing swagger ui with a custom openapi configuration
in an AWS S3 bucket.

Use in conjunction with CloudFront to create an globally, easily accessible swagger ui for a service

Written using terraform .12.x.

## Variables

### Required

- s3_bucket
  - The s3 bucket to install swagger ui and the openapi specification specified
- openapi_specification_path
  - Path to the custom openapi specification document to install

### Optional

- s3_acl
  - Default value is private
  - ACL associated with swagger ui. See https://docs.aws.amazon.com/cli/latest/reference/s3/sync.html for more details
- interpreter
  - Only required if using windows. Recommend using git bash
  - List of interpreter arguments. See https://www.terraform.io/docs/provisioners/local-exec.html for more details
- swagger_ui_version
  - Default value is latest
  - The version of swagger ui to use. Taken from https://github.com/swagger-api/swagger-ui/releases

## Outputs

- swagger_ui_version
  - The swagger ui version being used"
- openapi_specification_path
  - The path to the openapi specification

## Examples

### Running from a linux workstation

```
module "sc23_swagger_ui" {
  source = "../../terraform-aws-s3-swagger-ui"

  s3_bucket                  = "${aws_s3_bucket.sc2_swagger_ui.id}"
  openapi_specification_path = "${path.cwd}/specifications/sc2.yml"
  swagger_ui_version         = "latest"
}
```

### Running from a windows workstation

NOTE: In order to run from a windows workstation, you must specify a bash
interpreter. The only interpreter tested with windows is the git-bash interpreter.

```
module "wc3_swagger_ui" {
  source = "../../terraform-aws-s3-swagger-ui"

  s3_bucket                  = "${aws_s3_bucket.wc3_swagger_ui.id}"
  interpreter                = ["C:/Program Files/Git/bin/bash.exe", "-c"]
  openapi_specification_path = "${path.cwd}/specifications/wc3.yml"
  swagger_ui_version         = "latest"
}
```
