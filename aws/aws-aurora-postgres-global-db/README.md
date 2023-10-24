

    module "aurora_global_db" {
      count                        = var.env == "prod" ? 1 : 0
      source                       = "git@github.com:abc/terraform-modules.git//modules/aws-aurora-postgres-global-db?ref=v1.1.15"
      env                          = var.env
      team                         = var.team
      microservice_name            = var.service
      db_subnets                   = local.private_subnets
      vpc_id                       = local.vpc_id
      availability_zones           = var.availability_zones
      db_cluster_instance_class    = var.db_cluster_instance_class
      sns_topic                    = var.sns_topic
      security_group_id            = aws_security_group.db_sg.id
      engine_version               = var.db_engine_version
      master_password              = var.db_master_password
      master_username              = var.db_master_username
      backup_retention_period      = var.db_backup_retention_period
      port                         = var.db_port
      create_cpu_credit_alarm      = var.db_create_cpu_credit_alarm
      preferred_maintenance_window = var.db_preferred_maintenance_window
      preferred_backup_window      = var.db_preferred_backup_window
      db_instance_count            = var.db_instance_count
      GenieKey                     = var.GenieKey
      region                       = var.region
      database_name                = var.db_name
      parameter_group_family       = var.db_parameter_group_family
      snapshot_cluster               = local.snapshot_cluster
      db_cluster_snapshot_identifier = local.db_cluster_snapshot_identifier
      dr_region                    = var.region_dr
      dr_env                       = var.env_dr
      dr_private_subnets           = var.private_subnets_dr
      dr_security_group_id         = aws_security_group.db_sg_dr[0].id
      dr_sns_topic                 = var.sns_topic_dr
      dr_availability_zones        = var.availability_zones_dr #optional
      dbload_threshold             = var.dbload_threshold
    
      providers = {
        aws    = aws.primary
        aws.dr = aws.secondary
      }
    }
