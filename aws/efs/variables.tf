variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "vpc_cidr" {
  type = string
}

variable "service" {
  type        = string
  description = "Name of the service"
}

variable "tags" {
  type        = map(string)
  description = "To tag resources."
  default     = {}
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

# Optional. We have set sensible defaults

variable "encrypted" {
  type        = bool
  description = "If true, the disk will be encrypted."
  default     = true
}

variable "performance_mode" {
  type        = string
  description = "The file system performance mode. Can be either generalPurpose or maxIO"
  default     = "generalPurpose"
}

variable "throughput_mode" {
  type        = string
  description = "Throughput mode for the file system. Valid values: bursting, provisioned, or elastic."
  default     = "elastic"
}
