    module "s3_bucket" {
      source            = "git@github.com:abc/terraform-modules.git//modules/aws-s3-bucket?ref=v1.0.59"
      env               = var.env
      microservice_name = local.service_name
      team              = var.team
      company_name      = var.company_name # below are optional
      dr_env            = var.env_dr
      dr_region         = var.dr_region
      region            = var.region 
      create_lifecycle_config = var.create_lifecycle_config
      retention         = var.retention 
    }