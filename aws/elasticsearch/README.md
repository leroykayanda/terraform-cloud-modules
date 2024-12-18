

    module "elasticsearch" {
      source                    = "../_modules/elasticsearch"
      service                   = var.service
      env                       = local.env
      elasticsearch_version     = var.elasticsearch_version
      instance_type             = var.instance_type[local.env]
      subnet_ids                = var.subnet_ids[local.env]
      security_group_ids        = [aws_security_group.sg.id]
      tags                      = var.tags[local.env]
      master_user               = var.master_user[local.env]
      region                    = var.region
      sns_topic                 = var.sns_topic[local.env]
      ebs_volume_size           = var.ebs_volume_size
      instance_count            = var.instance_count
      zone_awareness_enabled    = var.zone_awareness_enabled
      availability_zone_count   = var.availability_zone_count
      advanced_security_options = var.advanced_security_options
    }
