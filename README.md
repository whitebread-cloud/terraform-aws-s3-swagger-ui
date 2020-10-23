# terraform-aws-s3-swagger-ui

- [Summary](#summary)
  - [Variables](#variables)
    - [Required](#required)
    - [Optional](#optional)
  - [Outputs](#outputs)
  - [Examples](#examples)
    - [Install Swagger UI](#install-swagger-ui)
    - [Install Swagger UI With URL](#install-swagger-ui-with-url)
    - [Install Swagger UI With Custom Specification](#install-swagger-ui-with-custom-specification)
    - [Install Swagger UI With URL And Custom Specification](#install-swagger-ui-with-url-and-custom-specification)
    - [Install Swagger UI With URLs And Custom Specifications](#install-swagger-ui-with-urls-and-custom-specifications)
    - [Install Swagger UI With All Optional Variables](#install-swagger-ui-with-all-optional-variables)

## Summary

Terraform module for installing swagger ui in an AWS S3 bucket.
Can pass openapi specification paths and/or openapi specification urls.

Passing openapi specification paths will upload the openapi specification files
to s3 and create a relative path in the swagger ui using the basename of the path
(the name of the file).

Passing openapi specification urls will create an absolute path in the
swagger ui for the url specified.

openapi specification urls take precedence over openapi specification paths
(openapi specifications are still uploaded) of the same index unless the openapi
specification url is an empty string.
You can reference openapi specification files located elsewhere as long as CORS
is enabled in the location being referenced.

Use in conjunction with CloudFront to create an globally, easily accessible swagger ui for services.

Written using terraform .12.x.
Requires aws-cli.

NOTE: See changelog if upgrading from .12.x to .13.x or above.

Special thanks to https://gist.github.com/denniswebb for his swagger-ui tf gist.

## Variables

### Required

- s3_bucket_path
  - The s3 bucket path to install swagger ui to.
    - E.g. super-awesome-swag-bucket or super-awesome-swag-bucket/yahaha

### Optional

- openapi_spec_paths
  - Default value is an empty list
    - Default value results in the default openapi specification url being used
      assuming openapi_spec_urls is also empty
  - Path to the custom openapi specification documents to install
    - E.g. ["/data/wc3/v1.yml"] or ["/data/wc3/v1.yml", "/data/wc3/v2.yml"]
- openapi_spec_urls
  - Default value is an empty list
    - Default value results in the default openapi specification url being using
      assuming openapi_spec_paths is also empty
  - URLs to the custom openapi specification documents for swagger ui to point to.
    - E.g. ["https://swagger.wc3.blizzardquotes.com/v1.yml"]
- swagger_ui_version
  - Default value is latest
  - The version of swagger ui to use. Taken from https://github.com/swagger-api/swagger-ui/releases
    - E.g. v3.24.0
- s3_acl
  - Default value is private
  - ACL associated with swagger ui. See https://docs.aws.amazon.com/cli/latest/reference/s3/sync.html for more details
    - E.g. public-read
- interpreter
  - Only required if using windows. Recommend using git bash. No longer necessary if using WSL 2
  - List of interpreter arguments. See https://www.terraform.io/docs/provisioners/local-exec.html for more details
    - E.g. ["C:/Program Files/Git/bin/bash.exe", "-c"]
- profile
  - Only required if not using the default profile or instance role
  - AWS profile to use. See https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html for more details
    - E.g blizzard-quotes

## Outputs

- swagger_ui_version
  - The swagger ui version being used

## Examples

### Install Swagger UI

Basic install of the swagger ui with no changes.

```
module "swagger_ui" {
  source = "github.com/whitebread-cloud/terraform-aws-s3-swagger-ui"

  s3_bucket_path = "super-awesome-swag-bucket"
}
```

### Install Swagger UI With URL

Install the swagger ui and point to an openapi specification.
Useful when the openapi specification has already been uploaded somewhere.
Requires CORS to be enabled where the openapi specification is hosted.

```
module "swagger_ui" {
  source = "github.com/whitebread-cloud/terraform-aws-s3-swagger-ui"

  s3_bucket_path    = "super-awesome-swag-bucket"
  openapi_spec_urls = ["https://swagger.sc2.blizzardquotes.com/wc3/v1.yml"]
}
```

### Install Swagger UI With Custom Specification

Install the swagger ui and inject an openapi specification
which the swagger ui will reference using a relative path.

```
module "swagger_ui" {
  source = "github.com/whitebread-cloud/terraform-aws-s3-swagger-ui"

  s3_bucket_path     = "super-awesome-swag-bucket"
  openapi_spec_paths = ["${path.cwd}/specifications/wc3/v1.yml"]
}
```

### Install Swagger UI With URL And Custom Specification

Install the swagger ui and inject an openapi specification which
the swagger ui will reference using the url specified instead of through
a relative path.

```
module "swagger_ui" {
  source = "github.com/whitebread-cloud/terraform-aws-s3-swagger-ui"

  s3_bucket_path      = "super-awesome-swag-bucket"
  openapi_spec_paths  = ["${path.cwd}/specifications/wc3/v1.yml"]
  openapi_spec_urls   = ["https://swagger.wc3.blizzardquotes.com/v1.yml"]
}
```

### Install Swagger UI With URLs And Custom Specifications

Example demonstrating unique use case.

Install the swagger ui and inject two openapi specifications which the
swagger ui will reference using a relative path
(empty string urls default to the path). Also point to another openapi
specification in another location using the url specified.

```
module "swagger_ui" {
  source = "github.com/whitebread-cloud/terraform-aws-s3-swagger-ui"

  s3_bucket_path      = "super-awesome-swag-bucket"
  openapi_spec_paths  = ["${path.cwd}/specifications/wc3/v1.yml", "${path.cwd}/specifications/wc3/v2.yml"]
  openapi_spec_urls   = ["", "", "https://swagger.sc2.blizzardquotes.com/v1.yml"]
}
```

### Install Swagger UI With All Optional Variables

Example demonstrating all optional variables being used.

In order to run from a windows workstation, you must specify a bash
interpreter. The only interpreter tested with windows is the git-bash interpreter.

```
module "swagger_ui" {
  source = "github.com/whitebread-cloud/terraform-aws-s3-swagger-ui"

  s3_bucket_path     = "super-awesome-swag-bucket"
  openapi_spec_paths = ["${path.cwd}/specifications/wc3/v1.yml"]
  openapi_spec_urls  = ["https://swagger.wc3.blizzardquotes.com/v1.yml"]
  swagger_ui_version = "v3.24.0"
  s3_acl             = "public-read"

  interpreter = ["C:/Program Files/Git/bin/bash.exe", "-c"]
  profile     = var.profile
}
```
