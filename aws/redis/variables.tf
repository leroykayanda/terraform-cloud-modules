variable "world" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the service"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "description" {
  type        = string
  description = "User-created description for the replication group. Must not be empty."
}

variable "node_type" {
  type        = string
  description = "Instance class to be used"
}

variable "num_cache_clusters" {
  type        = number
  description = "Number of cache clusters (primary and replicas) this replication group will have. If automatic_failover_enabled or multi_az_enabled are true, must be at least 2. Conflicts with num_node_groups and replicas_per_node_group. "
  default     = "2"
}

variable "multi_az_enabled" {
  type        = bool
  description = "Specifies whether to enable Multi-AZ Support for the replication group"
  default     = true

}

variable "automatic_failover_enabled" {
  type        = bool
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If enabled, num_cache_clusters must be greater than 1"
  default     = true
}

variable "parameter_group_name" {
  type        = string
  description = "Name of the parameter group to associate with this replication group."
}

variable "port" {
  type        = number
  description = "Port number on which each of the cache nodes will accept connections"
  default     = 6379
}

variable "engine" {
  type        = string
  description = "Name of the cache engine to be used for the clusters in this replication group. Valid values are redis or valkey."
  default     = "redis"
}

variable "engine_version" {
  type        = string
  description = "Version number of the cache engine to be used for the cache clusters in this replication group."
}

variable "at_rest_encryption_enabled" {
  type        = bool
  description = "Whether to enable encryption at rest"
  default     = true
}

variable "transit_encryption_enabled" {
  type        = bool
  description = "Whether to enable encryption in transit. Changing this argument with an engine_version < 7.0.5 will force a replacement. Engine versions prior to 7.0.5 only allow this transit encryption to be configured during creation of the replication group."
  default     = false
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Only supported for engine types redis and valkey and if the engine version is 6 or higher. "
  default     = true
}

variable "maintenance_window" {
  type        = string
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00"
  default     = "sat:02:00-sat:03:00"
}

variable "snapshot_window" {
  type        = string
  description = "Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period. Example: 05:00-09:00"
  default     = "00:00-01:00"
}

variable "subnets" {
  type        = list(string)
  description = "List of VPC Subnet IDs for the cache subnet group"
  default     = null
}

variable "security_groups" {
  type        = list(string)
  description = "List of security group ids to apply to the cluster"
}

variable "snapshot_retention_limit" {
  type        = string
  description = "Number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of snapshot_retention_limit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro cache nodes"
}

variable "sns_topic" {
  type        = map(string)
  description = "For alarm notifications"
  default     = null
}

variable "low_urgency_alarm_thresholds" {
  type = map(number)
  default = {
    freeable_memory = 2000000000 # 2 Gb
    cpu             = 80
  }
}

variable "high_urgency_alarm_thresholds" {
  type = map(number)
  default = {
    freeable_memory = 1000000000 # 1 Gb
    cpu             = 90
  }
}

variable "subnet_group_name" {
  type        = string
  description = "Name of the cache subnet group to be used for the replication group."
  default     = null
}

variable "auth_token_update_strategy" {
  type        = string
  description = "Strategy to use when updating the auth_token. Valid values are SET, ROTATE, and DELETE. Required if auth_token is set."
  default     = null
}
