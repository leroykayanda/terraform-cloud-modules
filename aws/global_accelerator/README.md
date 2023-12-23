    module "global_accelerator_prod" {
      source            = "modules/global_accelerator?ref=v1.1.43"
      env               = var.env
      microservice_name = var.service
      team              = var.team
      region            = var.region
      alb_arn           = module.ecs_service.alb_arn # below are optional
      dr_region         = var.region_dr
      dr_alb_arn        = module.ecs_service_dr[0].alb_arn
    }
