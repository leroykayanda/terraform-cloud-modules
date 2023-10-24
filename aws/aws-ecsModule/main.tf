
resource "aws_cloudwatch_log_group" "CloudWatchLogGroup" {
  name              = "${var.service_name}-container-logs"
  retention_in_days = 30
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "${var.service_name}-task-definition"
  task_role_arn            = var.task_execution_role
  execution_role_arn       = var.task_execution_role
  network_mode             = "awsvpc"
  requires_compatibilities = [var.launch_type]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_mem
  container_definitions = jsonencode(
    [
      {
        name         = var.container_name
        image        = var.container_image
        essential    = true
        network_mode = "awsvpc"

        environment = var.task_environment_variables == [] ? null : var.task_environment_variables

        secrets = var.task_secret_environment_variables == [] ? null : var.task_secret_environment_variables

        logConfiguration : {
          logDriver : "awslogs",
          options : {
            awslogs-group : aws_cloudwatch_log_group.CloudWatchLogGroup.name,
            awslogs-region : var.region,
            awslogs-stream-prefix : var.env
          }
        }

        portMappings = [
          {
            containerPort = var.container_port
          }
        ]
      }
    ]
  )

}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data "aws_ecs_task_definition" "task" {
  task_definition = aws_ecs_task_definition.ecs_task_definition.family
}

resource "aws_ecs_service" "ecs_service" {
  name    = var.service_name
  cluster = aws_ecs_cluster.ecs_cluster.id
  #task_definition                    = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count                      = var.desired_count
  launch_type                        = var.launch_type
  platform_version                   = "LATEST"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = 300
  task_definition                    = "${aws_ecs_task_definition.ecs_task_definition.family}:${max(aws_ecs_task_definition.ecs_task_definition.revision, data.aws_ecs_task_definition.task.revision)}"
  propagate_tags                     = "SERVICE"

  network_configuration {
    subnets         = var.task_subnets
    security_groups = [aws_security_group.task_sg.id]
  }
  lifecycle {
    ignore_changes = [desired_count]
  }

  load_balancer {
    target_group_arn = element(module.alb.target_group_arns, 0)
    container_name   = var.container_name
    container_port   = var.container_port
  }

  /* deployment_controller {
    type = "CODE_DEPLOY"
  } */

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }

}

resource "aws_appautoscaling_target" "ecs_app_scaling" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "scale"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_app_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_app_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_app_scaling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 600
    scale_out_cooldown = 30
  }
}

resource "aws_security_group" "task_sg" {
  name        = "${var.service_name}-allow-task-traffic"
  description = "Allow task inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Service Traffic"
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Database Traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "Redis Traffic"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "allow_task_traffic"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.service_name}-allow-alb-traffic"
  description = "Allow ALB inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Service Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Service Traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ALB health check traffic"
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "allow_alb_traffic"
  }
}

module "alb" {
  #https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/6.4.0
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name         = var.service_name
  internal     = var.internal
  idle_timeout = var.idle_timeout

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.alb_public_subnets
  security_groups = [aws_security_group.alb_sg.id]

  access_logs = {
    bucket  = var.alb_access_log_bucket
    prefix  = var.service_name
    enabled = true
  }

  target_groups = [
    {
      name_prefix          = "${var.env}-"
      backend_protocol     = "HTTP"
      backend_port         = var.container_port
      target_type          = "ip"
      deregistration_delay = var.deregistration_delay
      protocol_version     = "HTTP1"

      health_check = {
        enabled             = true
        interval            = 30
        path                = var.health_check_path
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.certificate_arn
      target_group_index = 0
      ssl_policy         = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
    }
  ]

  tags = {
    Environment = var.env
    waf         = var.waf
    Team        = var.team
  }
}

resource "aws_cloudwatch_metric_alarm" "hhc" {
  alarm_name          = "No-healthy-hosts-${var.service_name}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "This alarm monitors for when there are no healthy hosts"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"

  dimensions = {
    LoadBalancer = module.alb.lb_arn_suffix
    TargetGroup  = element(module.alb.target_group_arn_suffixes, 0)
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_cloudwatch_metric_alarm" "memory" {
  alarm_name          = "High-Memory-Utilization-${var.service_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"
  alarm_description   = "This alarm monitors for high ECS service memory"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"

  dimensions = {
    ServiceName = var.service_name
    ClusterName = var.cluster_name
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "High-CPU-Utilization-${var.service_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"
  alarm_description   = "This alarm monitors for high ECS service CPU"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"

  dimensions = {
    ServiceName = var.service_name
    ClusterName = var.cluster_name
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_cloudwatch_dashboard" "dash" {
  dashboard_name = var.service_name

  dashboard_body = jsonencode(
    {
      "widgets" : [
        {
          "height" : 7,
          "width" : 8,
          "y" : 0,
          "x" : 0,
          "type" : "metric",
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", module.alb.lb_arn_suffix]
            ],
            "region" : "${var.region}"
          }
        },
        {
          "type" : "metric",
          "x" : 8,
          "y" : 0,
          "width" : 8,
          "height" : 7,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", module.alb.lb_arn_suffix]
            ],
            "region" : "${var.region}"
          }
        },
        {
          "type" : "metric",
          "x" : 16,
          "y" : 0,
          "width" : 8,
          "height" : 7,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", element(module.alb.target_group_arn_suffixes, 0), "LoadBalancer", module.alb.lb_arn_suffix]
            ],
            "region" : "${var.region}"
          }
        },
        {
          "type" : "metric",
          "x" : 0,
          "y" : 7,
          "width" : 8,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/ApplicationELB", "UnHealthyHostCount", "TargetGroup", element(module.alb.target_group_arn_suffixes, 0), "LoadBalancer", module.alb.lb_arn_suffix],
              [".", "HealthyHostCount", ".", ".", ".", "."]
            ],
            "region" : "${var.region}"
          }
        },
        {
          "height" : 6,
          "width" : 8,
          "y" : 7,
          "x" : 8,
          "type" : "metric",
          "properties" : {
            "view" : "singleValue",
            "metrics" : [
              ["ECS/ContainerInsights", "DesiredTaskCount", "ServiceName", var.service_name, "ClusterName", var.cluster_name],
              [".", "PendingTaskCount", ".", ".", ".", "."],
              [".", "RunningTaskCount", ".", ".", ".", "."]
            ],
            "region" : "${var.region}",
            "period" : 300
          }
        },
        {
          "height" : 6,
          "width" : 8,
          "y" : 7,
          "x" : 16,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/ECS", "MemoryUtilization", "ServiceName", var.service_name, "ClusterName", var.cluster_name]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.region}",
            "period" : 300
          }
        },
        {
          "height" : 6,
          "width" : 8,
          "y" : 13,
          "x" : 0,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/ECS", "CPUUtilization", "ServiceName", var.service_name, "ClusterName", var.cluster_name]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.region}",
            "period" : 300
          }
        }
      ]
    }
  )
}








