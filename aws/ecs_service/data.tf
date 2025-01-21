data "aws_ecr_image" "ecr_image" {
  repository_name = var.ecr_repository
  most_recent     = true
}

data "aws_caller_identity" "current" {}

data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = var.cluster_name
} 
