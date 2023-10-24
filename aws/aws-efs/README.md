    module "efs" {
      source            = "git@github.com:abc/terraform-modules.git//modules/aws-efs?ref=v1.0.59"
      env               = var.env
      vpc_cidr          = var.vpc_cidr
      microservice_name = local.service_name
      team              = var.team
      vpc_id            = var.vpc_id
      private_subnets   = var.private_subnets
    }