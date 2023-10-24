resource "aws_globalaccelerator_accelerator" "globalaccelerator_accelerator" {
  name            = "${var.env}-${var.microservice_name}"
  ip_address_type = "IPV4"
  enabled         = true

  tags = {
    Environment = var.env
    Team        = var.team
  }

}

resource "aws_globalaccelerator_listener" "globalaccelerator_listener" {
  accelerator_arn = aws_globalaccelerator_accelerator.globalaccelerator_accelerator.id
  client_affinity = "NONE"
  protocol        = "TCP"

  port_range {
    from_port = 443
    to_port   = 443
  }
}

resource "aws_globalaccelerator_endpoint_group" "globalaccelerator_endpoint_group" {
  listener_arn            = aws_globalaccelerator_listener.globalaccelerator_listener.id
  endpoint_group_region   = var.region
  traffic_dial_percentage = 100

  endpoint_configuration {
    endpoint_id                    = var.alb_arn
    weight                         = 100
    client_ip_preservation_enabled = true
  }

  lifecycle {
    ignore_changes = [traffic_dial_percentage]
  }
}

resource "aws_globalaccelerator_endpoint_group" "globalaccelerator_endpoint_group_dr" {
  count                   = var.env == "prod" ? 1 : 0
  listener_arn            = aws_globalaccelerator_listener.globalaccelerator_listener.id
  endpoint_group_region   = var.dr_region
  traffic_dial_percentage = 0

  endpoint_configuration {
    endpoint_id                    = var.dr_alb_arn
    weight                         = 100
    client_ip_preservation_enabled = true
  }

  lifecycle {
    ignore_changes = [traffic_dial_percentage]
  }
}
