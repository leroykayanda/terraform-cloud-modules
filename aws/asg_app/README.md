

    module "asg_app" {
      source                    = "./modules/asg_app"
      service                   = var.service
      env                       = var.env
      region                    = var.region
      launch_template_settings  = var.launch_template_settings[var.env]
      servers_security_group    = aws_security_group.odoo_sg.id
      iam_instance_profile_name = aws_iam_instance_profile.ec2_instance_profile.name
      vpc_id                    = var.vpc_id[var.env]
      elb_settings              = var.elb_settings[var.env]
      elb_subnets               = var.public_subnets[var.env]
      elb_security_group        = aws_security_group.elb_sg.id
      vpc_subnets               = var.private_subnets[var.env]
      asg_settings              = var.asg_settings[var.env]
      block_device_mappings     = var.block_device_mappings # optional variables, we have set sensible defaults
      tags                      = var.tags[var.env]
      launch_template_tags      = var.launch_template_tags[var.env]
      sns_topic                 = var.sns_topic
      user_data                 = local.user_data
      enabled_metrics           = var.enabled_metrics
    }
