variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the service"
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "master_user" {
  type        = map(string)
  description = "Main user's credentials"
}

variable "region" {
  type = string
}

variable "sns_topic" {
  type        = string
  description = "SNS topic ARN for notifications"
}

variable "encrypt_at_rest" {
  type        = bool
  description = "Whether to enable encryption at rest"
  default     = true
}

variable "node_to_node_encryption" {
  type        = bool
  description = "Whether to enable node-to-node encryption"
  default     = true
}

variable "engine_version" {
  type    = string
  default = "OpenSearch_3.7"
}

variable "log_retention_days" {
  type    = number
  default = 7
}

variable "instance_type" {
  type    = string
  default = "t3.medium.search"
}

variable "ebs_options" {
  type = map(any)
  default = {
    ebs_enabled = true
    volume_size = 100
    iops        = 3000
    throughput  = 250
    volume_type = "gp3"
  }
}

variable "storage_alarm_threshold" {
  type        = number
  description = "Free storage threshold to alert on, as a percentage of the per-node EBS volume size"
  default     = 10
}

variable "tags" {
  type        = map(string)
  description = "Used to tag resources"
  default     = {}
}

variable "instance_count" {
  type        = number
  description = "Number of instances in the cluster."
  default     = 2
}

variable "zone_awareness_enabled" {
  type        = bool
  description = "Whether zone awareness is enabled, set to true for multi-az deployment."
  default     = true
}

variable "availability_zone_count" {
  type        = number
  description = "Number of Availability Zones for the domain to use with zone_awareness_enabled. Defaults to 2. Valid values: 2 or 3."
  default     = 2
}

variable "advanced_security_options" {
  type = map(any)
  default = {
    enabled                        = true
    internal_user_database_enabled = true
  }
}

variable "domain_endpoint_options" {
  type        = map(string)
  description = "Custom domain configs"
  default = {
    custom_endpoint_enabled         = false
    custom_endpoint                 = null
    custom_endpoint_certificate_arn = null
  }
}
