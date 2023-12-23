    module "cloudfront" {
      source              = "app.terraform.io/abc-Inc/modules/abc//aws/caches/cloudfront"
      version             = "1.1.39"
      env                 = local.workspace
      comment             = "${var.product}-${var.service}-${local.workspace}"
      team                = local.team
      lb_dns_name         = module.app.alb_dns_name
      acm_certificate_arn = var.acm_certificate_arn
      aliases             = var.aliases
    }
