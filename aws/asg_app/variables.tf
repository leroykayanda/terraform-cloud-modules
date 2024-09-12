variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the service"
}

variable "launch_template_settings" {
  type        = map(any)
  description = "Various settings for the launch template"
  default = {
    "image_id"                    = "ami-0565fa10f6359d178"
    "instance_type"               = "t3.medium"
    "key_name"                    = null
    "associate_public_ip_address" = false
  }
}

variable "servers_security_group" {
  type        = string
  description = "Security group used by the servers"
}

variable "elb_settings" {
  type        = map(any)
  description = "Various settings for the ELB"
  default = {
    "internal"                      = false
    "idle_timeout"                  = 300
    "load_balancer_type"            = "application"
    "access_logs_expiry"            = 180
    "target_group_port"             = 443
    "target_group_protocol"         = "HTTPS"
    "target_group_protocol_version" = "HTTP1"
    "health_check_path"             = "/"
    "health_check_matcher"          = "200-399"
    "health_check_protocol"         = "HTTPS"
    "deregistration_delay"          = 60
    "ssl_policy"                    = "ELBSecurityPolicy-TLS13-1-2-2021-06"
    "access_log_bucket"             = "my-bucket"
    certificate_arn                 = "arn:aws:acm:af-south-1:123:certificate/REDACTED"
  }
}

variable "vpc_id" {
  type = string
}

variable "elb_subnets" {
  type        = list(string)
  description = "Subnets for the ALB. Can be public or private"
  default     = []
}

variable "elb_security_group" {
  type        = string
  description = "SG used by the ELB"
  default     = null
}

variable "vpc_subnets" {
  type        = list(string)
  description = "For the Autoscaling Group"
  default     = []
}

variable "asg_settings" {
  type        = map(any)
  description = "Various settings for the ASG"
  default = {
    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 6
    default_cooldown          = 60
    default_instance_warmup   = 180
    health_check_grace_period = 300
    health_check_type         = "EC2"
    protect_from_scale_in     = false
  }
}

variable "block_device_mappings" {
  type        = map(any)
  description = "EBS volume properties. Lookup the value for device_name based on your AMI"
  default = {
    "device_name" = "/dev/sda1"
    "volume_size" = 200
    "volume_type" = "gp3"
  }
}

variable "iam_instance_profile_name" {
  type        = string
  description = "For EC2 instance permissions eg cloudwatch"
}

variable "region" {
  type = string
}

# For these variables, we have set sensible defaults but you can override them by passing them as module inputs

variable "tags" {
  type        = map(string)
  description = "To tag resources."
  default     = {}
}

variable "launch_template_tags" {
  type        = map(string)
  description = "To tag EC2 instances."
  default     = {}
}

variable "sns_topic" {
  type        = string
  description = "SNS topic ARN for notifications"
  default     = null
}

variable "user_data" {
  default = ""
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
