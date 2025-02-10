


    module "active_directory" {
      source     = "./modules/directory_service"
      password   = data.aws_ssm_parameter.password.value
      name       = var.name
      size       = var.size
      vpc_id     = module.vpc.vpc_id
      subnet_ids = module.vpc.private_subnets
      type       = var.directory_type
    }
