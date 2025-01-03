variable "world" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the service"
}

variable "role_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the IAM role that the proxy uses to access secrets in AWS Secrets Manager."
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "One or more VPC security group IDs to associate with the new proxy."
}

variable "vpc_subnet_ids" {
  type        = list(string)
  description = "One or more VPC security group IDs to associate with the new proxy."
}

variable "secret_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) representing the secret that the proxy uses to authenticate to the RDS DB instance or Aurora DB cluster."
}

# Optional

variable "debug_logging" {
  type        = bool
  description = "Whether the proxy includes detailed information about SQL statements in its logs."
  default     = false
}

variable "engine_family" {
  type        = string
  description = "The kinds of databases that the proxy can connect to. Valid values are MYSQL, POSTGRESQL, and SQLSERVER."
  default     = "POSTGRESQL"
}

variable "idle_client_timeout" {
  type        = number
  description = "The number of seconds that a connection to the proxy can be inactive before the proxy disconnects it."
  default     = 1800
}

variable "require_tls" {
  type        = bool
  description = "A Boolean parameter that specifies whether Transport Layer Security (TLS) encryption is required for connections to the proxy."
  default     = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "client_password_auth_type" {
  type        = string
  description = "The type of authentication the proxy uses for connections from clients. Valid values are MYSQL_NATIVE_PASSWORD, POSTGRES_SCRAM_SHA_256, POSTGRES_MD5, and SQL_SERVER_AUTHENTICATION"
  default     = "POSTGRES_SCRAM_SHA_256"
}

variable "iam_auth" {
  type        = string
  description = "Whether to require or disallow AWS Identity and Access Management (IAM) authentication for connections to the proxy. One of DISABLED, REQUIRED."
  default     = "DISABLED"
}

variable "connection_pool_config" {
  type        = map(string)
  description = "The settings that determine the size and behavior of the connection pool for the target group."
  default = {
    connection_borrow_timeout = 120
    max_connections_percent   = 100
  }
}

variable "db_instance_identifier" {
  type    = string
  default = null
}

variable "db_cluster_identifier" {
  type    = string
  default = null
}
