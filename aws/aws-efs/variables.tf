variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "vpc_cidr" {
  type = string
}

variable "microservice_name" {
  type        = string
  description = "Name of the service"
}

variable "team" {
  type        = string
  description = "For resource tags"
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

/* variable "sns_topic" {
  type        = string
  description = "SNS topic ARN for notifications"
  default     = ""
}
 */
