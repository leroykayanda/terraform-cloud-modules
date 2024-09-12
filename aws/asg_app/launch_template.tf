# Launch template
resource "aws_launch_template" "ecs_lt" {
  name                   = "${var.env}-${var.service}"
  image_id               = var.launch_template_settings["image_id"]
  instance_type          = var.launch_template_settings["instance_type"]
  key_name               = var.launch_template_settings["key_name"]
  update_default_version = true
  user_data              = base64encode(var.user_data)
  tags                   = var.tags

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  block_device_mappings {
    device_name = var.block_device_mappings["device_name"]
    ebs {
      volume_size = var.block_device_mappings["volume_size"]
      volume_type = var.block_device_mappings["volume_type"]
    }
  }

  network_interfaces {
    associate_public_ip_address = var.launch_template_settings["associate_public_ip_address"]
    security_groups             = [var.servers_security_group]
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.launch_template_tags
  }
}
