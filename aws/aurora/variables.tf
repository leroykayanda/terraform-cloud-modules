variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the service"
}

variable "db_subnets" {
  type        = list(string)
  description = "Subnets to create the db in"
}

variable "aurora_settings" {
  type = map(any)
  default = {
    "parameter_group_family"                 = "aurora-postgresql16"
    "engine"                                 = "aurora-postgresql",
    "engine_version"                         = "16.1",
    "engine_mode"                            = "provisioned",
    "serverless_cluster"                     = false
    "serverless_min_capacity"                = "0.5",
    "serverless_max_capacity"                = "8",
    "backup_retention_period"                = 35,
    "port"                                   = 5432,
    "instance_class"                         = "db.t4g.medium"
    "db_instance_count"                      = 1,
    "publicly_accessible"                    = false,
    "performance_insights_retention_period"  = 31
    "freeable_memory_alarm_threshold"        = 2000000000
    "disk_queue_depth_alarm_threshold"       = 200
    "buffer_cache_hit_ratio_alarm_threshold" = 80
    "dbload_alarm_threshold"                 = 2
  }
}

variable "db_credentials" {
  type        = map(string)
  description = "Db user and password"
  default = {
    "db_name"  = ""
    "user"     = ""
    "password" = ""
  }
}

variable "security_group_id" {
  type = string
}

variable "availability_zones" {
  type        = list(string)
  description = "For Aurora"
  default     = ["af-south-1a", "af-south-1b", "af-south-1c"]
}

variable "region" {
  type = string
}

# For these variables, we have set sensible defaults but you can override them by passing them as module inputs

variable "tags" {
  type        = map(string)
  description = "To tag resources."
  default     = {}
}

variable "creating_db" {
  type    = bool
  default = false
}

variable "snapshot_cluster" {
  type        = string
  description = "Cluster whose snapshot we are using"
  default     = null
}

variable "db_cluster_snapshot_identifier" {
  type    = string
  default = null
}

variable "preferred_maintenance_window" {
  type    = string
  default = "sun:00:00-sun:01:00"
}

variable "preferred_backup_window" {
  type    = string
  default = "02:00-03:00"
}

variable "enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = ["postgresql"]
}

variable "sns_topic" {
  type        = string
  description = "SNS topic ARN for notifications"
  default     = null
}
