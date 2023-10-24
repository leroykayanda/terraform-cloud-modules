resource "mongodbatlas_network_peering" "mongo_peer" {
  accepter_region_name   = var.region
  project_id             = var.project_id
  container_id           = var.container_id
  provider_name          = "AWS"
  route_table_cidr_block = var.route_table_cidr_block
  vpc_id                 = var.vpc_id
  aws_account_id         = data.aws_caller_identity.current.account_id
}

resource "aws_vpc_peering_connection_accepter" "connection_accepter" {
  vpc_peering_connection_id = mongodbatlas_network_peering.mongo_peer.connection_id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

resource "aws_route" "route_az_a" {
  route_table_id            = element(var.route_table_ids, 0)
  destination_cidr_block    = var.destination_cidr_block
  vpc_peering_connection_id = mongodbatlas_network_peering.mongo_peer.connection_id
}

resource "aws_route" "route_az_b" {
  route_table_id            = element(var.route_table_ids, 1)
  destination_cidr_block    = var.destination_cidr_block
  vpc_peering_connection_id = mongodbatlas_network_peering.mongo_peer.connection_id
}

resource "aws_route" "route_az_c" {
  route_table_id            = element(var.route_table_ids, 2)
  destination_cidr_block    = var.destination_cidr_block
  vpc_peering_connection_id = mongodbatlas_network_peering.mongo_peer.connection_id
}
