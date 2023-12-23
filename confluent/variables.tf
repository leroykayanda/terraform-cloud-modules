variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the service"
}

variable "availability" {
  type        = string
  description = "SINGLE_ZONE or MULTI_ZONE"
}

variable "region" {
  type = string
}
