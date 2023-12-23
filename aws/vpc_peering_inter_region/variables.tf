variable "accepter_cidr_block" {
  type        = string
  description = "AWS VPC CIDR block or subnet."
}

variable "requester_cidr_block" {
  type        = string
  description = "AWS VPC CIDR block or subnet."
}

variable "requester_route_table_ids" {
  type        = list(string)
  description = "For VPC peering routes"
}

variable "accepter_route_table_ids" {
  type        = list(string)
  description = "For VPC peering routes"
}

variable "vpc_id" {
  type = string
}

variable "peer_owner_id" {
  type        = string
  description = "Optional) The AWS account ID of the owner of the peer VPC. Defaults to the account ID the AWS provider is currently connected to."
}

variable "peer_vpc_id" {
  type = string
}

variable "peer_region" {
  type = string
}

variable "team" {
  type        = string
  description = "For tagging"
}

variable "env" {
  type = string
}

variable "connection_name" {
  type = string
}
