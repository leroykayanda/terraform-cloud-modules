variable "world" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the ECS service"
}

variable "container_name" {
  type        = string
  description = "Name of the container"
}

variable "task_execution_role" {
  type        = string
  description = "Task IAM role"
}

variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "cluster_arn" {
  type        = string
  description = "ARN of cluster to add this service to"
}

variable "ecr_repository" {
  type        = string
  description = "Name of the ECR repo"
}

# For these variables, we have set sensible defaults but you can override them by passing them as module inputs

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "cloudwatch_logs_retention" {
  type        = number
  description = "In days"
  default     = 30
}

variable "logging_type" {
  type        = string
  description = "cloudwatch or json-file"
  default     = "cloudwatch"
}

variable "two_containers" {
  description = "Does the task definition have two containers"
  default     = false
}

variable "container_name_2" {
  description = "Name of the second container"
  default     = null
}

variable "task_launch_type" {
  type        = string
  description = "EC2 or FARGATE"
  default     = "EC2"
}

variable "platform_version" {
  type        = string
  description = "Platform version on which to run your service. Only applicable for launch_type set to FARGATE. Defaults to LATEST"
  default     = null
}

variable "task_resources" {
  type        = map(number)
  description = "Hard limit for container CPU and Memory"
  default = {
    "cpu"    = 256
    "memory" = 512
  }
}

variable "create_volume" {
  description = "Attach EFS volume?"
  default     = false
}

variable "efs_volume_name" {
  type        = string
  description = "EFS volume name"
  default     = null
}

variable "efs_file_system_id" {
  type        = string
  description = "EFS filesystem Id"
  default     = null
}

variable "efs_access_point_id" {
  type        = string
  description = "EFS accesspoint Id"
  default     = null
}

variable "command" {
  type        = list(string)
  description = "Container CMD"
  default     = []
}

variable "user" {
  type        = string
  description = "Container user ID"
  default     = null
}

variable "entry_point" {
  type        = list(string)
  description = "Container Entrypoint"
  default     = []
}

variable "entry_point_2" {
  type        = list(string)
  description = "Container 2 Entrypoint"
  default     = []
}

variable "port_mappings" {
  type        = any
  description = "Port mappings allow containers to access ports on the host container instance to send or receive traffic."
  default     = []
}

variable "port_mappings_2" {
  type        = any
  description = "Port mappings for the second container"
  default     = []
}

variable "mount_points" {
  type        = list(map(string))
  description = "EFS mount point"
  default     = []
}

variable "task_environment_variables" {
  type    = list(map(string))
  default = []
}

variable "task_secret_environment_variables" {
  type    = list(map(string))
  default = []
}

variable "container_network_mode" {
  type    = string
  default = "bridge"
}

variable "service_autoscaling_settings" {
  type = map(number)
  default = {
    "desired_count" = 1
    "min_capacity"  = 1
    "max_capacity"  = 5
  }
}

variable "health_check_grace_period_seconds" {
  type    = number
  default = null
}

variable "task_subnets" {
  type        = list(string)
  description = "Subnets to be used to launch the ECS tasks. Only valid for FARGATE."
  default     = []
}

variable "task_security_group" {
  type        = string
  description = "Task security group. Only valid for FARGATE."
  default     = null
}

variable "load_balancer" {
  type        = map(any)
  description = "Loadbalancer configuration details"
  default = {
    uses_load_balancer               = false
    load_balancer_name               = ""
    load_balancer_listener_rule_path = "/*"
    vpc_id                           = null
    health_check_path                = "/"
  }
}

variable "load_balancer_defaults" {
  type        = map(any)
  description = "Loadbalancer default configuration details"
  default = {
    load_balancer_listener_port       = 443
    target_group_protocol             = "HTTP"
    target_group_deregistration_delay = 60
    target_group_protocol_version     = "HTTP1"
    health_protocol                   = "HTTP"
    health_matcher                    = "200-499"
  }
}

variable "sns_topic" {
  type        = string
  description = "For alarm notifications"
  default     = null
}

variable "active_alarms" {
  type        = map(bool)
  description = "Which alarms do you want to be created"
  default = {
    service_memory   = true
    service_cpu      = true
    running_tasks    = true
    pending_tasks    = true
    asg_max_capacity = true
  }
}

variable "alarm_periods" {
  type = map(number)
  default = {
    "service_memory" = 900 # 15min
    "service_cpu"    = 900 # 15min
    "running_tasks"  = 300 # 5min
    "pending_tasks"  = 900 # 15min
  }
}

variable "alarm_thresholds" {
  type = map(number)
  default = {
    "service_memory" = 90
    "service_cpu"    = 90
  }
}

variable "container_port" {
  type        = number
  description = "Port container listens on"
}
