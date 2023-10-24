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
  description = "For tagging"
}

variable "GenieKey" {
  type        = string
  description = "Opsgenie API key"
}

variable "region" {
  type = string
}

variable "log_group_arn" {
  type        = string
  description = "Cloudwatch log-group to monitor"
}

variable "log_group_name" {
  type        = string
  description = "Cloudwatch log-group to monitor"
}

variable "filter_pattern" {
  type = string
}

/* variable "log_group_name" {
  type        = string
  description = "Cloudwatch log-group to monitor"
}





variable "family" {
  type        = string
  description = "eg aurora-postgresql13"
}

variable "lambda_iam_role" {
  type = string
} */
