variable "world" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the service"
}

variable "db_subnets" {
  type        = list(string)
  description = "subnets to create the db in"
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "kms_key_deletion" {
  type        = number
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive."
  default     = 30
}

variable "allocated_storage" {
  type        = number
  description = "The allocated storage in gibibytes."
  default     = 500
}

variable "max_allocated_storage" {
  type        = number
  description = "Specifies the maximum storage (in GiB) that Amazon RDS can automatically scale to for this DB instance. By default, Storage Autoscaling is disabled. To enable Storage Autoscaling, set max_allocated_storage to greater than or equal to allocated_storage. Setting max_allocated_storage to 0 explicitly disables Storage Autoscaling. When configured, changes to allocated_storage will be automatically ignored as the storage can dynamically scale."
  default     = 0
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window."
  default     = false
}

variable "backup_retention_period" {
  type        = number
  description = "The days to retain backups for. Must be between 0 and 35."
  default     = 21
}

variable "db_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created."
  default     = null
}

variable "delete_automated_backups" {
  type        = bool
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
  default     = false
}

variable "deletion_protection" {
  default = true
}

variable "engine" {
  type        = string
  description = "The database engine to use eg. postgres, aurora-postgresql"
  default     = "postgres"
}

variable "engine_version" {
  type        = string
  description = "The engine version to use"
  default     = "17.2"
}

variable "instance_class" {
  type        = string
  description = "The instance type of the RDS instance."
}

variable "multi_az" {
  type        = bool
  description = "Specifies if the RDS instance is multi-AZ"
  default     = false
}

variable "storage_encrypted" {
  type        = bool
  description = "Specifies whether the DB instance is encrypted."
  default     = true
}

variable "db_username" {
  type    = string
  default = null
}

variable "db_password" {
  type    = string
  default = null
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true"
  default     = false
}

variable "port" {
  type        = number
  description = "The port on which the DB accepts connections."
  default     = 5432
}

variable "performance_insights_enabled" {
  type    = bool
  default = true
}

variable "performance_insights_retention_period" {
  type        = number
  description = "Amount of time in days to retain Performance Insights data. Valid values are 7, 731 (2 years) or a multiple of 31"
  default     = 93
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of VPC security groups to associate."
}

variable "maintenance_window" {
  type    = string
  default = "Sun:03:00-Sun:03:30"
}

variable "backup_window" {
  type        = string
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Must not overlap with maintenance_window.Eg: 00:00-02:00"
  default     = "01:00-01:30"
}

variable "storage_type" {
  type        = string
  description = "One of standard (magnetic), gp2 (general purpose SSD), gp3 (general purpose SSD that needs iops independently) io1 (provisioned IOPS SSD) or io2 (block express storage provisioned IOPS SSD)"
}

variable "iops" {
  type        = string
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of io1 or io2"
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "Set of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine). MySQL and MariaDB: audit, error, general, slowquery. PostgreSQL: postgresql, upgrade. MSSQL: agent , error. Oracle: alert, audit, listener, trace. eg ['postgresql']"
  default     = ["postgresql"]
}

variable "parameter_group_name" {
  type = string
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "iam_database_authentication_enabled" {
  type    = bool
  default = false
}

variable "low_urgency_alarm_thresholds" {
  type = map(number)
  default = {
    freeable_memory             = 50000000000   # 50Gb
    free_storage_space          = 3000000000000 # 3Tb
    cpu                         = 85
    disk_queue_depth            = 30
    read_latency                = 0.5 # 0.5s 
    write_latency               = 0.5 # 0.5s 
    iops                        = 30000
    replica_lag                 = 900            # 15min
    oldest_replication_slot_lag = "200000000000" #200 Gb
    db_load                     = 45
  }
}

variable "high_urgency_alarm_thresholds" {
  type = map(number)
  default = {
    freeable_memory             = 10000000000   # 10Gb
    free_storage_space          = 1000000000000 # 1Tb
    cpu                         = 100
    iops                        = 35000
    replica_lag                 = 1800           # 30min
    oldest_replication_slot_lag = "300000000000" #300 Gb
  }
}

variable "sns_topic" {
  type        = map(string)
  description = "For alarm notifications"
  default     = null
}

variable "replicate_source_db" {
  type        = string
  description = "Specifies that this resource is a Replica database, and to use this value as the source database"
  default     = null
}

variable "region" {
  type    = string
  default = "us-east-1"
}
