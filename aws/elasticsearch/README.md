    module "elasticsearch" {
      source                    = "../_modules/elasticsearch"
      service                   = var.service
      env                       = local.env
      elasticsearch_version     = var.elasticsearch_version
      instance_type             = var.instance_type[local.env]
      subnet_ids                = var.subnet_ids[local.env]
      security_group_ids        = [aws_security_group.sg.id]
      tags                      = var.tags[local.env]
      master_user               = var.master_user[local.env]
      region                    = var.region
      sns_topic                 = var.sns_topic[local.env]
      ebs_volume_size           = var.ebs_volume_size
      instance_count            = var.instance_count
      zone_awareness_enabled    = var.zone_awareness_enabled
      availability_zone_count   = var.availability_zone_count
      advanced_security_options = var.advanced_security_options
    }
Setting up SAML using Azure AD
[link-1](https://opster.com/guides/opensearch/opensearch-security/how-to-set-up-single-sign-on-using-active-directory-in-opensearch/)
[link-2](https://isar-nasimov.medium.com/aws-opensearch-saml-2-0-sso-via-azure-active-directory-cb68bc5b2c5d)