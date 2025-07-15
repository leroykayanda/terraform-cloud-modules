variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the ECS service"
}

variable "sns_topic" {
  type        = string
  description = "SNS topic ARN for notifications"
  default     = null
}

variable "delay_seconds" {
  type        = number
  default     = 0
  description = "The time in seconds that the delivery of all messages in the queue will be delayed."
}

variable "max_message_size" {
  type        = number
  default     = 262144
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB). The default for this attribute is 262144 (256 KiB)."
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours). The default for this attribute is 30."
  default     = 900 # 15 minutes
}

variable "message_retention_seconds" {
  type        = number
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). The default for this attribute is 345600 (4 days)."
  default     = 1209600 # 14 days
}

variable "receive_wait_time_seconds" {
  type        = number
  description = "Time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds). The default for this attribute is 0, meaning that the call will return immediately."
  default     = 0
}

variable "sqs_managed_sse_enabled" {
  type        = bool
  description = "Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys. "
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Used to tag resources"
  default     = {}
}

variable "alarm_thresholds" {
  type        = map(number)
  description = "Used to tag resources"
  default = {
    "approximate_number_of_messages_visible" = 50
    "approximate_age_of_oldest_message"      = 600
  }
}
