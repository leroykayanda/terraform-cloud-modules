provider "aws" {
  region = var.peer_region
  alias  = "peer"
}

resource "aws_vpc_peering_connection" "peer" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = var.peer_vpc_id
  vpc_id        = var.vpc_id
  peer_region   = var.peer_region
  auto_accept   = false

  tags = {
    Team        = var.team
    Environment = var.env
    Name        = var.connection_name
  }
}

resource "aws_vpc_peering_connection_accepter" "connection_accepter" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = {
    Side        = "Accepter"
    Team        = var.team
    Environment = var.env
    Name        = var.connection_name
  }
}

resource "aws_vpc_peering_connection_options" "requester" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  depends_on = [
    aws_vpc_peering_connection_accepter.connection_accepter
  ]

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.connection_accepter.id

  depends_on = [
    aws_vpc_peering_connection_accepter.connection_accepter
  ]

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

#requester routes
resource "aws_route" "requester_route" {
  for_each                  = toset(var.requester_route_table_ids)
  route_table_id            = each.key
  destination_cidr_block    = var.accepter_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

#accepter routes
resource "aws_route" "accepter_route" {
  provider                  = aws.peer
  for_each                  = toset(var.accepter_route_table_ids)
  route_table_id            = each.key
  destination_cidr_block    = var.requester_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
