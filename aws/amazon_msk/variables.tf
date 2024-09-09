variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the service"
}

variable "scram_credentials" {
  type        = map(string)
  description = "Sign-in credentials authentication for Amazon MSK using SASL/SCRAM"
  default = {
    username = "foo"
    password = "bar"
  }
}

variable "client_subnets" {
  type        = list(string)
  description = "A list of subnets to connect to in client VPC"
}

variable "region" {
  type = string
}

variable "kafka_security_group_id" {
  type        = string
  description = "Controls who can access kafka"
}

# For these variables, we have set sensible defaults but you can override them by passing them as module inputs

variable "sns_topic" {
  type        = string
  description = "For alarms"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Used to tag resources"
  default     = {}
}

variable "kafka_logs_retention_period" {
  type        = number
  description = "Cloudwatch logs retention in days"
  default     = 30
}

variable "kafka_settings" {
  type = map(any)
  default = {
    version                      = "3.5.1"
    default_replication_factor   = 2
    default_partitions_per_topic = 2
    default_log_retention_hours  = 168 # 7 days
    number_of_broker_nodes       = 2
    enhanced_monitoring_level    = "DEFAULT"
    instance_type                = "kafka.t3.small"
    broker_ebs_volume_size       = 100
    public_access                = "DISABLED"
    broker_memory_in_gb          = 2
  }
}
