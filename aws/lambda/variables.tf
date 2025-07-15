variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the ECS service"
}

variable "iam_role" {
  type        = string
  description = "Amazon Resource Name (ARN) of the function's execution role. The role provides the function's identity and access to AWS services and resources."
}

variable "tags" {
  type        = map(string)
  description = "To tag resources."
  default     = {}
}

variable "cloudwatch_log_retention" {
  type        = number
  description = "In days"
  default     = 30
}

variable "package_type" {
  type        = string
  description = "Lambda deployment package type. Valid values are Zip and Image"
  default     = "Image"
}

variable "image_uri" {
  type        = string
  description = "ECR image URI containing the function's deployment package. Exactly one of filename, image_uri, or s3_bucket must be specified."
  default     = null
}

variable "timeout" {
  type        = number
  description = "Amount of time your Lambda Function has to run in seconds."
  default     = 900
}

variable "memory_size" {
  type        = number
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  default     = 128
}

variable "env_variables" {
  type        = map(any)
  description = "Map of environment variables that are accessible from the function code during execution"
  default     = {}
}

variable "region" {
  type = string
}

variable "subnets" {
  type    = list(string)
  default = []
}

variable "security_group_id" {
  type    = string
  default = null
}

variable "needs_vpc" {
  type    = bool
  default = false
}

variable "ephemeral_storage" {
  type        = number
  description = "The size of the Lambda function Ephemeral storage(/tmp) represented in MB. The minimum supported ephemeral_storage value defaults to 512MB and the maximum supported value is 10240MB."
  default     = 512
}

variable "sns_topic" {
  type        = string
  description = "For alarms"
  default     = null
}
