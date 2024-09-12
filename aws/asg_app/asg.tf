resource "aws_autoscaling_group" "asg" {
  name                      = "${var.env}-${var.service}"
  vpc_zone_identifier       = var.vpc_subnets
  desired_capacity          = var.asg_settings["desired_capacity"]
  max_size                  = var.asg_settings["max_size"]
  min_size                  = var.asg_settings["min_size"]
  capacity_rebalance        = true
  default_cooldown          = var.asg_settings["default_cooldown"]
  default_instance_warmup   = var.asg_settings["default_instance_warmup"]
  health_check_grace_period = var.asg_settings["health_check_grace_period"]
  health_check_type         = var.asg_settings["health_check_type"]
  metrics_granularity       = "1Minute"
  enabled_metrics           = var.enabled_metrics
  protect_from_scale_in     = var.asg_settings["protect_from_scale_in"]
  target_group_arns         = [aws_lb_target_group.target_group.arn]

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  instance_maintenance_policy {
    min_healthy_percentage = 100
    max_healthy_percentage = 200
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      desired_capacity
    ]
  }

}
