variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the service"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets to create the db in"
}

variable "aurora_settings" {
  type = map(any)
  default = {
    "parameter_group_family"                 = "aurora-postgresql17"
    "engine"                                 = "aurora-postgresql",
    "engine_version"                         = "17.7",
    "backup_retention_period"                = 14,
    "instance_class"                         = "db.t4g.medium"
    "db_instance_count"                      = 1,
    "publicly_accessible"                    = false,
    "performance_insights_retention_period"  = 31
    "freeable_memory_alarm_threshold"        = 1000000000 # 1GB
    "disk_queue_depth_alarm_threshold"       = 200
    "buffer_cache_hit_ratio_alarm_threshold" = 80
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

variable "promotion_tier" {
  type    = number
  default = 2
}

variable "storage_type" {
  type        = string
  description = "Specifies the storage type to be associated with the DB cluster. Valid values are: \"\", aurora-iopt1 (Aurora DB Clusters)"
  default     = ""
}

variable "availability_zones" {
  type        = list(string)
  description = "For Aurora"
  default     = ["af-south-1a", "af-south-1b", "af-south-1c"]
}

variable "allow_major_version_upgrade" {
  type        = bool
  description = "Enable to allow major engine version upgrades"
  default     = false
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Enable to allow minor engine version upgrades"
  default     = false
}

variable "performance_insights_enabled" {
  type        = bool
  description = "Enable Performance Insights for the DB cluster"
  default     = true
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "Copy tags to DB cluster snapshots"
  default     = true
}


variable "tags" {
  type        = map(string)
  description = "To tag resources."
  default     = {}
}

variable "restoring_snaphot" {
  type        = bool
  description = "Are you restoring DB from a snapshot"
  default     = false
}

variable "snapshot_cluster" {
  type        = string
  description = "Cluster whose snapshot we are using"
  default     = null
}

variable "db_cluster_snapshot_identifier" {
  type        = string
  description = "Name of the snapshort we are restoring"
  default     = null
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

variable "region" {
  type = string
}

variable "sns_topic" {
  type        = string
  description = "SNS topic ARN for notifications"
}

variable "port" {
  type        = number
  description = "Port on which the database listens"
  default     = 5432
}

variable "apply_immediately" {
  type        = bool
  description = "Whether to apply changes immediately"
  default     = true
}

variable "engine_mode" {
  type        = string
  description = "Database engine mode"
  default     = "provisioned"
}

variable "deletion_protection" {
  type        = bool
  description = "If the DB cluster should have deletion protection enabled"
  default     = true
}

variable "serverless_cluster" {
  type        = bool
  description = "Provision an Aurora Serverless v2 cluster instead of a provisioned cluster"
  default     = false
}

variable "storage_encrypted" {
  type        = bool
  description = "Specifies whether the DB cluster is encrypted"
  default     = true
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  default     = false
}
