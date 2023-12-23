output "datadog_monitor_id" {
  value       = element(concat(datadog_monitor.this.*.id, tolist([""])), 0)
  description = "ID of the Datadog monitor"
}

output "datadog_monitor_name" {
  value       = element(concat(datadog_monitor.this.*.name, tolist([""])), 0)
  description = "Name of the Datadog monitor"
}