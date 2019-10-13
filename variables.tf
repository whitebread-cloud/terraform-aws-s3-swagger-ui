variable "openapi_specification_path" {
  description = "Path to the custom openapi specification document to install"
}

variable "swagger_ui_version" {
  default     = "latest"
  description = "The version of swagger ui to use. Taken from https://github.com/swagger-api/swagger-ui/releases"
}

variable "s3_acl" {
  default     = "private"
  description = "ACL associated with swagger ui. See https://docs.aws.amazon.com/cli/latest/reference/s3/sync.html for more details"
}

variable "s3_bucket" {
  description = "The s3 bucket to install swagger ui and the openapi specification specified"
}

variable "interpreter" {
  type        = "list"
  default     = []
  description = "List of interpreter arguments. See https://www.terraform.io/docs/provisioners/local-exec.html for more details"
}

variable "profile" {
  default     = "default"
  description = "AWS profile to use. See https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html for more details"
}