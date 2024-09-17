variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the service"
}

variable "region" {
  type = string
}

variable "mq_credentials" {
  type        = map(string)
  description = "Sign-in credentials authentication to Amazon MQ"
}

variable "subnet_ids" {
  type        = list(string)
  description = "To set up MQ in"
}

variable "mq_settings" {
  type = map(any)
  default = {
    engine_type                    = "RabbitMQ"
    engine_version                 = "3.13"
    host_instance_type             = "mq.t3.micro"
    deployment_mode                = "SINGLE_INSTANCE"
    publicly_accessible            = true
    storage_type                   = "ebs"
    ready_messages_alarm_threshold = 100
  }
}

# For these variables, we have set sensible defaults but you can override them by passing them as module inputs

variable "sns_topic" {
  type        = string
  description = "For alarms"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Used to tag resources"
  default     = {}
}
