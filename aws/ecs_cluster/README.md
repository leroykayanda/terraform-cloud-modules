

    module "ecs_cluster" {
      source                       = "../aws-ecs-cluster"
      service                      = var.service
      image_id                     = var.image_id
      world                        = var.world # The parameters below are optional and have sensible defaults. Review to see which ones need to be changed. 
      tags                         = var.tags[var.world]
      key_name                     = var.key_name[var.world]
      instance_security_group      = aws_security_group.instance_security_group.id
      vpc_subnets                  = var.vpc_subnets[var.world]
      iam_instance_profile         = aws_iam_instance_profile.ecs_instance_profile.name
      user_data                    = local.user_data
      cluster_autoscaling_settings = var.cluster_autoscaling_settings[var.world]
      capacity_provider            = var.capacity_provider
      instance_type                = var.instance_type
      block_device_mappings        = var.block_device_mappings
      default_cooldown             = var.default_cooldown
      default_instance_warmup      = var.default_instance_warmup
      health_check_grace_period    = var.health_check_grace_period
      health_check_type            = var.health_check_type
      enabled_metrics              = var.enabled_metrics
      associate_public_ip_address  = var.associate_public_ip_address
      asg_autoscaling_settings     = var.asg_autoscaling_settings
    }



Sample user data

    locals {
      user_data = <<-EOF
          #!/bin/bash
          echo "Sample script"
    EOF
    }
