variable "name" {
  type        = string
  description = "The fully qualified name for the directory, such as corp.example.com"
}

variable "password" {
  type        = string
  description = "The password for the directory administrator or connector user."
}

variable "size" {
  type        = string
  description = "(For SimpleAD and ADConnector types) The size of the directory (Small or Large are accepted values). Large by default."
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "The identifiers of the subnets for the directory servers (2 subnets in 2 different AZs)."
}

# Optional

variable "tags" {
  type    = map(string)
  default = {}
}

variable "type" {
  type        = string
  description = "The directory type (SimpleAD, ADConnector or MicrosoftAD are accepted values). Defaults to SimpleAD."
  default     = "SimpleAD"
}
