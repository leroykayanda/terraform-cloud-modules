variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "tags" {
  type        = map(string)
  description = "Used to tag resources"
  default     = {}
}

variable "service" {
  type        = string
  description = "Name of the service"
}

variable "hash_key" {
  type        = string
  description = "Attribute to use as the hash (partition) key. Must also be defined as an attribute."
}

variable "range_key" {
  type        = string
  description = "Attribute to use as the range (sort) key. Must also be defined as an attribute"
}

variable "billing_mode" {
  type        = string
  description = "Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST"
  default     = "PAY_PER_REQUEST"
}

variable "table_class" {
  type        = string
  description = "Storage class of the table. Valid values are STANDARD and STANDARD_INFREQUENT_ACCESS"
  default     = "STANDARD"
}

variable "attributes" {
  type        = list(map(string))
  description = "Set of nested attribute definitions."
}

variable "point_in_time_recovery_enabled" {
  type        = bool
  description = "Enable point-in-time recovery"
  default     = true
}

variable "recovery_period_in_days" {
  type        = number
  description = "Number of preceding days for which continuous backups are taken and maintained"
  default     = 15
}

variable "server_side_encryption_enabled" {
  type        = bool
  description = "Enable encryption at rest. Whether or not to enable encryption at rest using an AWS managed KMS customer master key (CMK). If enabled is false then server-side encryption is set to AWS-owned key (shown as DEFAULT in the AWS console). Potentially confusingly, if enabled is true and no kms_key_arn is specified then server-side encryption is set to the default KMS-managed key (shown as KMS in the AWS console). "
  default     = false
}

variable "deletion_protection_enabled" {
  type        = bool
  description = "Enables deletion protection for table."
  default     = true
}
