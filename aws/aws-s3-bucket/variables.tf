variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "microservice_name" {
  type        = string
  description = "Name of the ECS service"
}

variable "team" {
  type        = string
  description = "For resource tags"
}

variable "company_name" {
  type        = string
  description = "For bucket name to be globally unique"
}

variable "retention" {
  type        = number
  description = "In days"
  default     = 365
}

variable "dr_env" {
  type    = string
  default = "dr"
}

variable "dr_region" {
  type    = string
  default = "eu-west-2"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "create_lifecycle_config" {
  default = "yes"
}
