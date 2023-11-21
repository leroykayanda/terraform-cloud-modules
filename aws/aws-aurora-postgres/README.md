    module "aurora" {
      source                       = "git@github.com:abc/terraform-modules.git//modules/aws-aurora-postgres?ref=v1.0.9"
      env                          = var.env
      team                         = var.team
      microservice_name            = var.microservice_name
      db_subnets                   = var.private_subnets
      vpc_id                       = var.vpc_id
      availability_zones           = var.availability_zones
      db_cluster_instance_class    = var.db_cluster_instance_class
      sns_topic                    = var.sns_topic
      security_group_id            = aws_security_group.db_security_group.id
      engine_version               = var.db_engine_version
      master_password              = var.master_password
      master_username              = var.db_master_username
      port                         = var.db_port
      db_instance_count            = var.db_instance_count
      database_name                = var.database_name
      region                       = var.region
      parameter_group_family       = local.db_parameter_group_family #these are optional
      backup_retention_period      = var.db_backup_retention_period
      create_cpu_credit_alarm      = var.db_create_cpu_credit_alarm
      preferred_maintenance_window = var.preferred_maintenance_window
      preferred_backup_window      = var.preferred_backup_window
    }