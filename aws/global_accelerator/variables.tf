variable "env" {
  type        = string
  description = "The environment i.e prod, dev etc"
}

variable "microservice_name" {
  type = string
}

variable "team" {
  type        = string
  description = "Used to tag resources"
}

variable "region" {
  type = string
}

variable "alb_arn" {
  type = string
}

variable "dr_alb_arn" {
  type    = string
  default = null
}

variable "dr_region" {
  type    = string
  default = "eu-west-2"
}
