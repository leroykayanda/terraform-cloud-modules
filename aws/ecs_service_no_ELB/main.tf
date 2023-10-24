resource "aws_cloudwatch_log_group" "CloudWatchLogGroup" {
  name              = "${var.service_name}-container-logs"
  retention_in_days = 365

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "${var.service_name}-task-definition"
  task_role_arn            = var.task_execution_role
  execution_role_arn       = var.task_execution_role
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_mem

  dynamic "volume" {
    for_each = var.create_volume == "yes" ? [1] : []
    content {
      name = var.volume_name
      efs_volume_configuration {
        file_system_id     = var.file_system_id
        root_directory     = "/"
        transit_encryption = "ENABLED"

        authorization_config {
          access_point_id = var.access_point_id
          iam             = "DISABLED"
        }
      }
    }
  }

  container_definitions = jsonencode(
    [
      {
        name         = var.container_name
        image        = var.container_image
        essential    = true
        network_mode = "awsvpc"
        command      = var.command
        entryPoint   = var.entrypoint
        user         = var.user
        mountPoints  = var.mountPoints

        portMappings = var.portMappings

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
      }
    ]
  )

}

data "aws_ecs_task_definition" "task" {
  task_definition = aws_ecs_task_definition.ecs_task_definition.family
}

resource "aws_ecs_service" "ecs_service" {
  name                               = var.service_name
  cluster                            = var.cluster_arn
  desired_count                      = var.desired_count
  platform_version                   = "LATEST"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  task_definition                    = "${aws_ecs_task_definition.ecs_task_definition.family}:${max(aws_ecs_task_definition.ecs_task_definition.revision, data.aws_ecs_task_definition.task.revision)}"
  propagate_tags                     = "SERVICE"
  enable_execute_command             = true

  network_configuration {
    subnets         = var.task_subnets
    security_groups = [var.task_sg]
  }
  lifecycle {
    ignore_changes = [desired_count]
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = var.capacity_provider
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }

}

resource "aws_appautoscaling_target" "ecs_app_scaling" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.ecs_service.name}"
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
  treat_missing_data  = "ignore"

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
  treat_missing_data  = "ignore"

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
