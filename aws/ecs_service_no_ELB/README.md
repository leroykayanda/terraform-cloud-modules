This module sets up an ECS service with no ELB.

    module "ecs_service_no_ELB" {
      source                            = "git@github.com:abc/terraform-modules.git//modules/ecs_service_no_ELB?ref=v1.0.41"
      cluster_arn                       = module.ecs_cluster.arn
      container_image                   = var.container_image
      container_name                    = local.service_name
      env                               = var.env
      region                            = var.region
      service_name                      = "${var.env}-${local.service_name}"
      task_execution_role               = aws_iam_role.execution_role.arn
      fargate_cpu                       = var.fargate_cpu
      fargate_mem                       = var.fargate_mem
      task_environment_variables        = []
      task_secret_environment_variables = var.shared_environment_variables
      desired_count                     = var.desired_count
      task_subnets                      = var.private_subnets
      vpc_id                            = var.vpc_id
      vpc_cidr                          = var.vpc_cidr
      min_capacity                      = var.min_capacity
      max_capacity                      = var.max_capacity
      cluster_name                      = module.ecs_cluster.name
      sns_topic                         = var.sns_topic
      team                              = var.team
      capacity_provider                 = var.capacity_provider
      task_sg                           = aws_security_group.task_sg.id #optional variables follow
      command                           = var.command
      user                              = var.user
      create_volume                     = "yes"
      volume_name                       = "worker-logs"
      file_system_id                    = module.efs.id
      mountPoints                       = var.mountPoints
      access_point_id                   = module.efs.access_point_id
    }
