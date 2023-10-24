variable "team" {
  type        = string
  description = "Name of the team"
}

variable "env" {
  type = string
}

variable "service" {
  type        = string
  description = "Name of the service or component"
}

variable "endpoint" {
  type        = string
  description = "An HTTPS endpoint to subscribe to SNS"
}

variable "dlq_arn" {
  type = string
}
