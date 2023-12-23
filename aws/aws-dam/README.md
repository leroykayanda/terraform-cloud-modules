
    module "dam" {
      source            = "modules/aws-dam?ref=v1.0.12"
      env               = var.env
      microservice_name = var.microservice_name
      team              = "devops"
      GenieKey          = var.GenieKey
      log_group_name    = "/aws/rds/cluster/${var.env}-${var.microservice_name}/postgresql"
      log_group_arn     = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/rds/cluster/${var.env}-${var.microservice_name}/postgresql"
      region            = var.region
      family            = var.db_parameter_group_family
    }
