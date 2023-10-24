variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "microservice_name" {
  type        = string
  description = "Name of the ECS service"
}

variable "team" {
  type        = string
  description = "Used to tag resources"
}

variable "kafka_client_subnets" {
  type        = list(string)
  description = "Subnets to create brokers in"
}

variable "broker_ebs_volume_size" {
  type        = number
  description = "The size in GiB of the EBS volume for the data drive on each broker node. Minimum value of 1 and maximum value of 16384"
}

variable "broker_instance_type" {
  type        = string
  description = "Specify the instance type to use for the kafka brokersE.g., kafka.m5.large"
}

variable "kafka_version" {
  type        = string
  description = "eg 2.8.1"
}

variable "number_of_broker_nodes" {
  type = number
}

variable "kafka_enhanced_monitoring" {
  type        = string
  description = "Specify the desired enhanced MSK CloudWatch monitoring level e.g PER_BROKER,DEFAULT."
}

variable "kafka_logs_retention_period" {
  type        = number
  description = "Cloudwatch logs retention in days"
}

variable "security_group_id" {
  type = string
}

variable "public_access" {
  type        = string
  description = "Public access type. Valida values: DISABLED, SERVICE_PROVIDED_EIPS"
}

variable "scram_user" {
  type = string
}

variable "scram_password" {
  type = string
}
