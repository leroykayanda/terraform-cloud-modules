resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  count             = var.logging_type == "cloudwatch" ? 1 : 0
  name              = "${var.world}-${var.service}-${var.container_name}-container-logs"
  retention_in_days = var.cloudwatch_logs_retention
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group_2" {
  count             = var.logging_type == "cloudwatch" && var.two_containers == true ? 1 : 0
  name              = "${var.world}-${var.service}-${var.container_name_2}-container-logs"
  retention_in_days = var.cloudwatch_logs_retention
  tags              = var.tags
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "${var.world}-${var.service}-task-definition"
  task_role_arn            = var.task_execution_role
  execution_role_arn       = var.task_execution_role
  network_mode             = var.container_network_mode
  requires_compatibilities = [var.task_launch_type]
  cpu                      = var.task_resources["cpu"]
  memory                   = var.task_resources["memory"]

  dynamic "volume" {
    for_each = var.create_volume == "yes" ? [1] : []
    content {
      name = var.efs_volume_name
      efs_volume_configuration {
        file_system_id     = var.efs_file_system_id
        root_directory     = "/"
        transit_encryption = "ENABLED"

        authorization_config {
          access_point_id = var.efs_access_point_id
          iam             = "DISABLED"
        }
      }
    }
  }

  container_definitions = jsonencode(
    var.two_containers == true ?
    [
      {
        name         = var.container_name
        image        = local.container_image
        essential    = true
        network_mode = var.container_network_mode
        command      = var.command
        user         = var.user
        mountPoints  = var.mount_points
        entryPoint   = var.entry_point
        environment  = var.task_environment_variables == [] ? null : var.task_environment_variables
        secrets      = var.task_secret_environment_variables == [] ? null : var.task_secret_environment_variables

        logConfiguration = var.logging_type == "cloudwatch" ? {
          logDriver : "awslogs",
          options : {
            awslogs-group : aws_cloudwatch_log_group.cloudwatch_log_group[0].name,
            awslogs-region : var.region,
            awslogs-stream-prefix : var.world
          }
          } : var.logging_type == "json-file" ? {
          logDriver : "json-file",
          options : {
            "max-size" : "10m",
            "max-file" : "3"
          }
        } : null

        portMappings = var.port_mappings
      },
      {
        name         = var.container_name_2
        image        = local.container_image
        essential    = true
        network_mode = var.container_network_mode
        command      = var.command
        user         = var.user
        mountPoints  = var.mount_points
        entryPoint   = var.entry_point_2

        environment = var.task_environment_variables == [] ? null : var.task_environment_variables

        secrets = var.task_secret_environment_variables == [] ? null : var.task_secret_environment_variables

        logConfiguration = var.logging_type == "cloudwatch" ? {
          logDriver : "awslogs",
          options : {
            awslogs-group : aws_cloudwatch_log_group.cloudwatch_log_group[0].name,
            awslogs-region : var.region,
            awslogs-stream-prefix : var.world
          }
          } : var.logging_type == "json-file" ? {
          logDriver : "json-file",
          options : {
            "max-size" : "10m",
            "max-file" : "3"
          }
        } : null

        portMappings = var.port_mappings_2
      }
    ]
    :
    [
      {
        name         = var.container_name
        image        = local.container_image
        essential    = true
        network_mode = var.container_network_mode
        command      = var.command
        user         = var.user
        mountPoints  = var.mount_points
        entryPoint   = var.entry_point
        environment  = var.task_environment_variables == [] ? null : var.task_environment_variables
        secrets      = var.task_secret_environment_variables == [] ? null : var.task_secret_environment_variables

        logConfiguration = var.logging_type == "cloudwatch" ? {
          logDriver : "awslogs",
          options : {
            awslogs-group : aws_cloudwatch_log_group.cloudwatch_log_group[0].name,
            awslogs-region : var.region,
            awslogs-stream-prefix : var.world
          }
          } : var.logging_type == "json-file" ? {
          logDriver : "json-file",
          options : {
            "max-size" : "10m",
            "max-file" : "3"
          }
        } : null

        portMappings = var.port_mappings
      }
    ]
  )

}

data "aws_ecs_task_definition" "task" {
  task_definition = aws_ecs_task_definition.ecs_task_definition.family
}

resource "aws_ecs_service" "ecs_service" {
  name                               = "${var.world}-${var.service}"
  cluster                            = var.cluster_arn
  desired_count                      = var.service_autoscaling_settings["desired_count"]
  platform_version                   = var.platform_version
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  task_definition                    = "${aws_ecs_task_definition.ecs_task_definition.family}:${max(aws_ecs_task_definition.ecs_task_definition.revision, data.aws_ecs_task_definition.task.revision)}"
  propagate_tags                     = "SERVICE"
  enable_execute_command             = true

  dynamic "network_configuration" {
    for_each = var.task_launch_type == "FARGATE" ? [1] : []
    content {
      subnets         = var.task_subnets
      security_groups = [var.task_security_group]
    }
  }

  dynamic "load_balancer" {
    for_each = var.create_elb ? [1] : []
    content {
      target_group_arn = aws_lb_target_group.target_group[0].arn
      container_name   = var.container_name
      container_port   = var.elb_settings["container_port"]
    }
  }

  dynamic "load_balancer" {
    for_each = var.existing_elb_settings["use_existing_elb"] ? [1] : []
    content {
      target_group_arn = var.existing_elb_settings["target_group_arn"]
      container_name   = var.container_name
      container_port   = var.existing_elb_settings["container_port"]
    }
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.task_launch_type == "EC2" ? [1] : []
    content {
      type  = "binpack"
      field = "cpu"
    }
  }

  lifecycle {
    ignore_changes = [desired_count, capacity_provider_strategy]
  }

  tags = var.tags
}

resource "aws_appautoscaling_target" "ecs_app_scaling" {
  max_capacity       = var.service_autoscaling_settings["max_capacity"]
  min_capacity       = var.service_autoscaling_settings["min_capacity"]
  resource_id        = "service/${var.world}-${var.cluster_name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
