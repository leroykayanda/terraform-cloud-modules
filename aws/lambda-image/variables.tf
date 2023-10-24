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

variable "iam_role" {
  type = string
}

variable "image_uri" {
  type = string
}

variable "timeout" {
  type = number
}

variable "memory_size" {
  type = number
}

variable "env_variables" {
  type = map(any)
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
  type    = string
  default = "no"
}

variable "ephemeral_storage" {
  type    = number
  default = 512
}
