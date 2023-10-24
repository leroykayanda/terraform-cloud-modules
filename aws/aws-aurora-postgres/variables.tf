variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "microservice_name" {
  type        = string
  description = "Name of the service"
}

variable "team" {
  type        = string
  description = "For resource tags"
}

variable "region" {
  type = string
}


variable "db_subnets" {
  type        = list(string)
  description = "subnets to create the db in"
}

variable "vpc_id" {
  type = string
}

variable "availability_zones" {
  type        = list(string)
  description = "For Aurora"
}

variable "db_cluster_instance_class" {
  type        = string
  description = "Aurora DB instance class"
}

variable "sns_topic" {
  type        = string
  description = "SNS topic ARN for notifications"
  default     = ""
}

variable "security_group_id" {
  type = string
}

variable "engine_version" {
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type = string
}

variable "backup_retention_period" {
  type = number
}

variable "port" {
  type = number
}

variable "database_name" {
  type = string
}

variable "create_cpu_credit_alarm" {
  type        = string
  description = "Create alarm only if a burstable instance class has been chosen. Possible values - yes or no"
}

variable "preferred_maintenance_window" {
  type = string
}

variable "preferred_backup_window" {
  type = string
}

variable "db_instance_count" {
  type = number
}

variable "db_cluster_snapshot_identifier" {
  type = string
}

variable "snapshot_cluster" {
  type        = string
  description = "cluster whose snapshot we are using"
}

variable "parameter_group_family" {
  type        = string
  description = "eg aurora-postgresql13"
}

variable "creating_db" {
  type    = bool
  default = false
}
