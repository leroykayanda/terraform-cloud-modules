
    module "aurora_db" {
      source             = "./modules/aurora"
      service            = var.service
      env                = var.env
      tags               = var.tags[var.env]
      db_subnets         = var.db_subnets[var.env]
      aurora_settings    = var.aurora_settings[var.env]
      db_credentials     = var.db_credentials[var.env]
      availability_zones = var.db_availability_zones
      security_group_id  = aws_security_group.db_sg.id
      region             = var.region
      sns_topic          = var.sns_topic[var.env]
    }
