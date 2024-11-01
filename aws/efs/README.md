

    module "efs" {
      source           = "../_modules/efs"
      env              = local.env
      vpc_cidr         = var.vpc_cidr[local.env]
      service          = var.service
      tags             = var.tags[local.env]
      vpc_id           = var.vpc_id[local.env]
      private_subnets  = var.private_subnets[local.env] # Optional, we have set sensible defaults
      encrypted        = var.encrypted
      performance_mode = var.performance_mode
      throughput_mode  = var.throughput_mode
    }
