resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.world}-${var.service}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  count              = contains(["FARGATE", "FARGATE_SPOT"], var.capacity_provider) ? 1 : 0
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = var.capacity_provider
  }
}

resource "aws_ecs_cluster_capacity_providers" "ec2_capacity_provider" {
  count              = var.capacity_provider == "EC2" ? 1 : 0
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.capacity_provider[0].name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.capacity_provider[0].name
  }
}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  count = var.capacity_provider == "EC2" ? 1 : 0
  name  = "${var.world}-${var.service}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg[0].arn
    managed_termination_protection = var.cluster_autoscaling_settings["managed_termination_protection"]

    managed_scaling {
      maximum_scaling_step_size = var.cluster_autoscaling_settings["maximum_scaling_step_size"]
      minimum_scaling_step_size = var.cluster_autoscaling_settings["minimum_scaling_step_size"]
      status                    = "ENABLED"
      target_capacity           = var.cluster_autoscaling_settings["target_capacity"]
      instance_warmup_period    = var.default_instance_warmup
    }
  }
}

resource "aws_launch_template" "ecs_lt" {
  count                  = var.capacity_provider == "EC2" ? 1 : 0
  name                   = "${var.world}-${var.service}"
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  update_default_version = true
  user_data              = var.user_data == null ? null : base64encode(var.user_data)
  tags                   = var.tags

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  block_device_mappings {
    device_name = var.block_device_mappings["device_name"]
    ebs {
      volume_size = var.block_device_mappings["volume_size"]
      volume_type = var.block_device_mappings["volume_type"]
    }
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = [var.instance_security_group]
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  count                     = var.capacity_provider == "EC2" ? 1 : 0
  name                      = "${var.world}-${var.service}"
  vpc_zone_identifier       = var.vpc_subnets
  desired_capacity          = var.asg_autoscaling_settings["desired_capacity"]
  max_size                  = var.asg_autoscaling_settings["max_size"]
  min_size                  = var.asg_autoscaling_settings["min_size"]
  capacity_rebalance        = true
  default_cooldown          = var.default_cooldown
  default_instance_warmup   = var.default_instance_warmup
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  metrics_granularity       = "1Minute"
  enabled_metrics           = var.enabled_metrics
  protect_from_scale_in     = true

  launch_template {
    id      = aws_launch_template.ecs_lt[0].id
    version = "$Latest"
  }

  instance_maintenance_policy {
    min_healthy_percentage = 100
    max_healthy_percentage = 200
  }

  tag {
    key                 = "Name"
    value               = "${var.world}-${var.service}-ASG"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      desired_capacity
    ]
  }

}
