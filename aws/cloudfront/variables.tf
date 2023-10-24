variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "team" {
  type        = string
  description = "For resource tags"
}

variable "lb_dns_name" {
  type = string
}

variable "comment" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "aliases" {
  type        = list(string)
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
}
