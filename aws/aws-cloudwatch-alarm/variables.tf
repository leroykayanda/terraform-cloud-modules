variable "team_name" {
  type        = string
  description = "Name of the team"
}

variable "env" {
  type        = string
  description = "The deployment environment. prod, stage, sand, dev, dr"
  default     = "dev"
}

variable "region" {
  type        = string
  description = "The aws region"
  default     = "eu-west-1"
}

variable "service_name" {
  type        = string
  description = "Name of the service or component"
}

variable "alarm_name" {
  type        = string
  description = "Alarm name"
}


variable "comparison_operator" {
  type    = string
  default = "GreaterThanOrEqualToThreshold"
}

variable "metric_name" {
  type = string
}

variable "metric_namespace" {
  type = string
}

variable "statistic" {
  type    = string
  default = "Maximum"
}

variable "threshold" {
  type    = string
  default = "1"
}

variable "alarm_description" {
  type    = string
  default = "This alarm monitors for the specified threshold"
}

variable "treat_missing_data" {
  type    = string
  default = "missing"
}

variable "sns_topic_name" {
  type        = string
  description = "The SNS arn where cloudwatch sends alerts to"
}

variable "dimensions" {
  type        = map(string)
  description = "Dimensions of the metrics"
}
