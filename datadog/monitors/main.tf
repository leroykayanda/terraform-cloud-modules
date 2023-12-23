resource "datadog_monitor" "this" {
  message = var.monitor_message
  name    = var.monitor_name
  query   = var.monitor_query
  type    = var.monitor_type
  count   = var.monitor_enable ? 1 : 0

  dynamic "monitor_thresholds" {
    for_each = var.monitor_threshold
    content {
      warning           = monitor_thresholds.value["warning"]
      warning_recovery  = monitor_thresholds.value["warning_recovery"]
      critical          = monitor_thresholds.value["critical"]
      critical_recovery = monitor_thresholds.value["critical_recovery"]
    }
  }
  notify_no_data     = var.monitor_notify_no_data
  renotify_interval  = var.monitor_renotify_interval
  escalation_message = var.monitor_escalation_message
  notify_audit       = var.monitor_notify_audit
  include_tags       = var.monitor_include_tags
  tags = compact(concat(
    [
      "managed-by:terraform",
      "team:${var.team}",
      "service:${var.service}",
      "env:${var.environment}",
      "repository:${local.repository}"
    ],
    var.monitor_tags
  ))
  evaluation_delay    = var.monitor_evaluation_delay
  require_full_window = var.monitor_require_full_window
  priority            = var.monitor_priority
}

locals {
  repository = var.monitor_repository != "" ? var.monitor_repository : "https://github.com/abcHQ/${var.product}-${var.service}"
}
