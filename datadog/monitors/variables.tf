variable "product" {
  description = "Organisation name"
  type        = string
  default     = "abc"
}
variable "monitor_message" {
  type        = string
  description = "Message to be displayed in the monitor. Email notifications can be sent to specific users by using the same @username notation as events."
}
variable "monitor_name" {
  type        = string
  description = "Name of the monitor."
}

variable "monitor_query" {
  type        = string
  description = "Query to be used for the monitor "
}

variable "monitor_type" {
  type        = string
  default     = "metric alert"
  description = "Type of the monitor. Valid values are: composite, event alert, log alert, metric alert, process alert, query alert, rum alert, service check, synthetics alert, trace-analytics alert, slo alert, event-v2 alert, audit alert, ci-pipelines alert, error-tracking alert."

}

variable "monitor_threshold" {
  type = list(object({
    warning           = number
    warning_recovery  = number
    critical          = number
    critical_recovery = number

  }))
  description = "Alert thresholds to be used for the monitor."
  default = [
    {
      warning           = null
      warning_recovery  = null
      critical          = null
      critical_recovery = null
    }
  ]

}

variable "monitor_notify_no_data" {
  type        = bool
  default     = false
  description = "Whether this monitor will notify when data stops reporting."
}

variable "monitor_renotify_interval" {
  type        = number
  default     = 60
  description = "How often (in seconds) to re-notify on an alert. The number of minutes after the last notification before a monitor will re-notify on the current status"

}

variable "monitor_escalation_message" {
  type        = string
  default     = null
  description = "message to include with a re-notification. Supports the @username notification allowed elsewhere."
}

variable "monitor_notify_audit" {
  type        = bool
  default     = false
  description = "whether tagged users will be notified on changes to this monitor."
}

variable "monitor_include_tags" {
  type        = bool
  default     = true
  description = " whether notifications from this monitor automatically insert its triggering tags into the title."
}

variable "monitor_tags" {
  type        = list(string)
  description = "Tags to be added to the monitor."
}

variable "team" {
  type        = string
  description = "Team to managing the app"
}

variable "service" {
  type        = string
  description = "Service of the application"
}

variable "monitor_enable" {
  type        = bool
  default     = true
  description = "Enable monitor in Datadog Monitor"
}

variable "environment" {
  type        = string
  description = "Environment of the application"
}

variable "monitor_evaluation_delay" {
  type        = number
  default     = null
  description = "Evaluation delay of the monitor"
}

variable "monitor_require_full_window" {
  type        = bool
  default     = null
  description = "Decide if we should require full data window before evaluating monitor or not. We set the default to null as Datadog has it's own logic to set the value to true or false. This variable  will allow us to force the behavior we want"
}

variable "monitor_priority" {
  type        = number
  default     = null
  description = <<EOF
Priority of the Monitor.
- 1: Critical
- 2: High
- 3: Medium
- 4: Info
- 5: Low
- Null: Undefined
EOF

  validation {
    condition = (
      var.monitor_priority == null ? true : (
        var.monitor_priority >= 1 &&
        var.monitor_priority <= 5
      )
    )
    error_message = "Monitor priority must be null or a number between 1 and 5."
  }
}

variable "monitor_repository" {
  type        = string
  default     = ""
  description = "Repository URL where the monitor has been defined"
}
