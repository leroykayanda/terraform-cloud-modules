variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "team" {
  type        = string
  description = "Used to tag resources"
}

variable "microservice_name" {
  type        = string
  description = "Name of the service"
}

variable "ddb_hash_key" {
  type = string
}

variable "ddb_billing_mode" {
  type = string
}

variable "ddb_range_key" {
  type = string
}

variable "ddb_attributes" {
  type = list(map(string))
}

variable "ddb_replica_region_name" {
  type = string
}
