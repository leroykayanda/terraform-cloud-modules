variable "company_name" {
  type        = string
  description = "Name of the ECS service"
}

variable "team" {
  type        = string
  description = "Used to tag resources"
}

variable "include_map" {
  type        = list(any)
  description = "A map of lists of accounts and OU's to include in the firewall manager policy"
}
