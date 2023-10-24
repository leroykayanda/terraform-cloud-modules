variable "team_name" {
  type        = string
  description = "Name of the team"
}

variable "environment" {
  type        = string
  description = "The deployment environment. Production, Staging, Sandbox, Development"
  default     = "Development"
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

variable "dashboard_name" {
  type        = string
  description = "Dashboard name"
}


variable "metrics" {
  type        = list(map(string))
  description = "A nested list for metrics"
}
