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


# Optional

variable "elasticsearch_version" {
  type    = string
  default = "7.10"
}

variable "instance_type" {
  type    = string
  default = "t3.medium.search"
}

variable "ebs_volume_size" {
  type    = number
  default = 100
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
