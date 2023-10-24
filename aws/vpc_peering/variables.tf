variable "vpc_id" {
  type = string
}

variable "route_table_cidr_block" {
  type        = string
  description = "AWS VPC CIDR block or subnet."
}

variable "project_id" {
  type        = string
  description = "The unique ID for the MongoDB Atlas project "
}

variable "region" {
  type = string
}

variable "container_id" {
  type        = string
  description = "Unique identifier of the MongoDB Atlas container for the provider (GCP) or provider/region (AWS, AZURE)"
}

variable "route_table_ids" {
  type        = list(string)
  description = "For VPC peering routes"
}

variable "destination_cidr_block" {
  type        = string
  description = "CIDR in remote VPC peer"
}

