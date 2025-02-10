variable "world" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the ECS service"
}

variable "image_id" {
  type        = string
  description = "AMI"
}

# For these variables, we have set sensible defaults but you can override them by passing them as module inputs

variable "capacity_provider" {
  type        = string
  description = "Short name of the ECS capacity provider. EC2 or FARGATE"
  default     = "EC2"
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "asg_autoscaling_settings" {
  type = map(string)
  default = {
    "desired_capacity" = 1
    "min_size"         = 1
    "max_size"         = 2
  }
}

variable "default_cooldown" {
  type    = number
  default = 60
}

variable "default_instance_warmup" {
  type    = number
  default = 60
}

variable "health_check_grace_period" {
  type    = number
  default = 300
}

variable "health_check_type" {
  type        = string
  description = "EC2 or ELB"
  default     = "EC2"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name"
  default     = null
}

variable "instance_security_group" {
  type        = string
  description = "SG Id"
  default     = null
}

variable "vpc_subnets" {
  type        = list(string)
  description = "For the Autoscaling Group"
  default     = []
}

variable "iam_instance_profile" {
  type        = string
  description = "Role that will be assumed by instances."
  default     = null
}

variable "user_data" {
  default = null
}

variable "tags" {
  type        = map(string)
  description = "To tag resources."
  default     = {}
}

variable "enabled_metrics" {
  type        = list(string)
  description = "For the Autoscaling Group"
  default = [
    "GroupAndWarmPoolDesiredCapacity",
    "GroupAndWarmPoolTotalCapacity",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances",
    "WarmPoolDesiredCapacity",
    "WarmPoolMinSize",
    "WarmPoolPendingCapacity",
    "WarmPoolTerminatingCapacity",
    "WarmPoolTotalCapacity",
    "WarmPoolWarmedCapacity",
  ]
}

variable "cluster_autoscaling_settings" {
  type = map(any)
  default = {
    "managed_termination_protection" = "ENABLED"
    "minimum_scaling_step_size"      = 1
    "maximum_scaling_step_size"      = 3
    "target_capacity"                = 80
  }
}

variable "associate_public_ip_address" {
  description = "Should the container instances have public IPs"
  default     = false
}

variable "block_device_mappings" {
  type        = map(any)
  description = "EBS volume properties"
  default = {
    "device_name" = "/dev/xvda"
    "volume_size" = 100
    "volume_type" = "gp3"
  }
}

variable "active_alarms" {
  type        = map(bool)
  description = "Which alarms do you want to be created"
  default = {
    asg_memory               = true
    asg_cpu                  = true
    container_instance_count = true
    asg_max_capacity_usage   = true
  }
}

variable "alarm_thresholds" {
  type = map(number)
  default = {
    "asg_memory"             = 90
    "asg_cpu"                = 90
    "asg_max_capacity_usage" = 90
  }
}

variable "alarm_periods" {
  type = map(number)
  default = {
    "asg_memory"               = 900 # 15min
    "asg_cpu"                  = 900 # 15min
    "container_instance_count" = 300 # 5min
    "asg_max_capacity_usage"   = 900 # 15min
  }
}

variable "sns_topic" {
  type = string
}
