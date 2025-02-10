
    module "client_vpn" {
      source                 = "./modules/client_vpn"
      description            = var.description
      vpc_id                 = module.vpc.vpc_id
      client_cidr_block      = var.client_cidr_block
      server_certificate_arn = var.server_certificate_arn
      active_directory_id    = module.active_directory.directory_id
      security_group_ids     = [aws_security_group.vpn_access.id]
      tags                   = merge(var.tags, { Name = var.description })
      type                   = var.authentication_type
      dns_servers            = var.dns_servers
      split_tunnel           = var.split_tunnel
      self_service_portal    = var.self_service_portal
      subnet_ids             = [element(module.vpc.private_subnets, 1)]
      target_network_cidrs   = [var.vpc_cidr, "0.0.0.0/0"]
    }
