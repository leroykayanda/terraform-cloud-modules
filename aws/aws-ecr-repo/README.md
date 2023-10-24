    module "ecr_repo" {
      source            = "git@github.com:abc/terraform-modules.git//modules/aws-ecr-repo?ref=v1.0.9"
      env               = var.env
      microservice_name = "${var.microservice_name}"
    }