# terraform-aws-s3-swagger-ui

## Summary

Terraform module for installing swagger ui with a custom openapi specification
in an AWS S3 bucket.

Use in conjunction with CloudFront to create an globally, easily accessible swagger ui for a service.

Written using terraform .12.x.

Special thanks to https://gist.github.com/denniswebb for his swagger-ui tf gist.

## Variables

### Required

- openapi_spec_path
  - Path to the custom openapi specification document to install
- s3_bucket_path
  - The s3 bucket path to install swagger ui and the openapi specification specified.
    e.g. super-awesome-bucket or super-awesome-bucket/yahaha

### Optional

- openapi_spec_url
  - Default value is an empty string (which results in the swagger ui using a relative path)
  - "URL to the custom openapi specification document for swagger ui to point to. Will perform a relative path lookup if not specified
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

- openapi_spec_s3_dest_path
  - The s3 path to the openapi specification
- swagger_ui_version
  - The swagger ui version being used"

## Examples

### Running from a linux workstation

```
module "swagger_ui" {
  source = "github.com/whitebread-cloud/terraform-aws-s3-swagger-ui"

  openapi_spec_path = "${path.cwd}/../specifications/${var.game}.yml"
  s3_bucket_path                  = var.s3_swagger_bucket
}
```

### Running from a windows workstation

In order to run from a windows workstation, you must specify a bash
interpreter. The only interpreter tested with windows is the git-bash interpreter.

```
module "swagger_ui" {
  source = "github.com/whitebread-cloud/terraform-aws-s3-swagger-ui"

  openapi_spec_path = "${path.cwd}/../specifications/${var.game}.yml"
  swagger_ui_version         = "v3.24.0"
  s3_acl                     = "public"
  s3_bucket_path                  = var.s3_swagger_bucket
  interpreter                = ["C:/Program Files/Git/bin/bash.exe", "-c"]
  profile                    = "blizzard-quotes"
}
```
