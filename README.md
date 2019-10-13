# terraform-aws-s3-swagger-ui

## Summary

Terraform module for installing swagger ui with a custom openapi specification
in an AWS S3 bucket.

Use in conjunction with CloudFront to create an globally, easily accessible swagger ui for a service.

Written using terraform .12.x.

Special thanks to https://gist.github.com/denniswebb for his swagger-ui tf gist.

## Variables

### Required

- openapi_specification_path
  - Path to the custom openapi specification document to install
- s3_bucket
  - The s3 bucket to install swagger ui and the openapi specification specified

### Optional

- swagger_ui_version
  - Default value is latest
  - The version of swagger ui to use. Taken from https://github.com/swagger-api/swagger-ui/releases
- s3_acl
  - Default value is private
  - ACL associated with swagger ui. See https://docs.aws.amazon.com/cli/latest/reference/s3/sync.html for more details
- interpreter
  - Only required if using windows. Recommend using git bash
  - List of interpreter arguments. See https://www.terraform.io/docs/provisioners/local-exec.html for more details
- profile
  - Only required if not using the default profile or instance role
  - AWS profile to use. See https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html for more details

## Outputs

- swagger_ui_version
  - The swagger ui version being used"
- openapi_specification_path
  - The path to the openapi specification

## Examples

### Running from a linux workstation

```
module "swagger_ui" {
  source = "github.com/whitebread-cloud/terraform-aws-s3-swagger-ui"

  openapi_specification_path = "${path.cwd}/../specifications/${var.game}.yml"
  s3_bucket                  = var.s3_swagger_bucket
}
```

### Running from a windows workstation

In order to run from a windows workstation, you must specify a bash
interpreter. The only interpreter tested with windows is the git-bash interpreter.

```
module "swagger_ui" {
  source = "github.com/whitebread-cloud/terraform-aws-s3-swagger-ui"

  openapi_specification_path = "${path.cwd}/../specifications/${var.game}.yml"
  swagger_ui_version         = "v3.24.0"
  s3_acl                     = "public"
  s3_bucket                  = var.s3_swagger_bucket
  interpreter                = ["C:/Program Files/Git/bin/bash.exe", "-c"]
  profile                    = "blizzard-quotes"
}
```
