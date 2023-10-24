variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the ECS service"
}

variable "env_variables" {
  type = map(string)
  default = {
  }
}

variable "team" {
  type        = string
  description = "For resource tags"
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "timeout" {
  type = number
}

variable "iam_role" {
  type = string
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "filename" {
  type = string
}

variable "ephemeral_storage" {
  type    = number
  default = 512
}

/* 

variable "subnets" {
  type = list(string)
}

variable "security_group_id" {
  type    = string
  default = null
}

variable "needs_vpc" {
  type    = string
  default = "no"
} */
