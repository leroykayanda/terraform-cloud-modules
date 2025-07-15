resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = var.description
  client_cidr_block      = var.client_cidr_block
  server_certificate_arn = var.server_certificate_arn
  security_group_ids     = var.security_group_ids
  vpc_id                 = var.vpc_id
  tags                   = var.tags
  dns_servers            = var.dns_servers
  split_tunnel           = var.split_tunnel
  self_service_portal    = var.self_service_portal
  session_timeout_hours  = var.session_timeout_hours

  authentication_options {
    type                = var.authentication_type
    active_directory_id = var.active_directory_id
    saml_provider_arn   = var.saml_provider_arn
  }

  connection_log_options {
    enabled = false
  }

  client_login_banner_options {
    banner_text = "Successfully connected to VPN"
    enabled     = true
  }

}

resource "aws_ec2_client_vpn_network_association" "vpn_subnets" {
  count                  = length(var.subnet_ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = element(var.subnet_ids, count.index)
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  count                  = length(var.target_network_cidrs)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = element(var.target_network_cidrs, count.index)
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "internet" {
  count                  = length(var.subnet_ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  destination_cidr_block = "0.0.0.0/0"
  target_vpc_subnet_id   = element(var.subnet_ids, count.index)
}
