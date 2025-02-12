data "aws_ecr_image" "ecr_image" {
  repository_name = var.ecr_repository
  most_recent     = true
}

data "aws_caller_identity" "current" {}

data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = var.cluster_name
}

data "aws_lb" "lb" {
  count = var.load_balancer["uses_load_balancer"] ? 1 : 0
  name  = var.load_balancer["load_balancer_name"]
}

data "aws_lb_listener" "listener" {
  count             = var.load_balancer["uses_load_balancer"] ? 1 : 0
  load_balancer_arn = data.aws_lb.lb[0].arn
  port              = var.load_balancer_defaults["load_balancer_listener_port"]
}
