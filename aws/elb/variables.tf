variable "service" {
  type        = string
  description = "Name of the application"
}

variable "internal" {
  type        = bool
  description = "If true, the LB will be internal. Defaults to false."
  default     = false
}

variable "load_balancer_type" {
  type        = string
  description = "Type of load balancer to create. Possible values are application, gateway, or network. The default value is application."
  default     = "application"
}

variable "world" {
  type        = string
  description = "Name of the environment"
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs to attach to the LB. For Load Balancers of type network subnets can only be added (see Availability Zones), deleting a subnet for load balancers of type network will force a recreation of the resource."
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to assign to the resource"
  default     = {}
}

variable "create_access_logs_bucket" {
  type        = bool
  default     = true
  description = "Whether to create ELB access logs bucket or not"
}

variable "company_name" {
  type        = string
  description = "To make the ELB access log bucket name unique"
}

variable "elb_access_log_expiration" {
  type        = number
  description = "Days after which to delete ELB access logs"
  default     = 30
}

variable "ingress_ports" {
  type        = list(number)
  description = "Which ports should be allowed inbound"
  default     = [80, 443]
}

variable "idle_timeout" {
  type        = number
  description = "Time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application. Default: 60."
  default     = 60
}

variable "client_keep_alive" {
  type        = number
  description = "The value you choose specifies the maximum amount of time a client connection can remain open, regardless of the activity on the connection. The client keep alive duration begins when the connection is initially established and does not reset. When the client keep alive duration period has elapsed, the load balancer closes the connection. Valid range is 60 - 604800 seconds. The default is 3600 seconds, or 1 hour."
  default     = 3600
}

variable "enable_http2" {
  type        = bool
  description = "Whether HTTP/2 is enabled in application load balancers. Defaults to true."
  default     = true
}

variable "certificate_arn" {
  type        = string
  description = "SSL cert"
}

variable "ssl_policy" {
  type        = string
  description = "Policy ELB listener will use"
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}
