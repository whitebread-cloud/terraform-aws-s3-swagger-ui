variable "openapi_spec_paths" {
  type        = list(string)
  default     = []
  description = "Paths to the custom openapi specification documents to install"
}

variable "openapi_spec_urls" {
  default     = []
  description = "URLs to the custom openapi specifications documents for swagger ui to point to"
}

variable "swagger_ui_version" {
  default     = "latest"
  description = "The version of swagger ui to use. Taken from https://github.com/swagger-api/swagger-ui/releases"
}

variable "s3_acl" {
  default     = "private"
  description = "ACL associated with swagger ui. See https://docs.aws.amazon.com/cli/latest/reference/s3/sync.html for more details"
}

variable "s3_bucket_path" {
  description = "The s3 bucket path to install swagger ui and the openapi specifications specified. e.g. super-awesome-bucket_path or super-awesome-bucket_path/yahaha"
}

variable "interpreter" {
  type        = list(string)
  default     = []
  description = "List of interpreter arguments. See https://www.terraform.io/docs/provisioners/local-exec.html for more details"
}

variable "profile" {
  default     = "default"
  description = "AWS profile to use. See https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html for more details"
}
