

    module "ecr_repo" {
      source               = "./modules/ecr_repo"
      env                  = var.env
      service              = var.service
      image_tag_mutability = var.image_tag_mutability
    }
