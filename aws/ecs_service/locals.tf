locals {
  container_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repository}:${element(data.aws_ecr_image.ecr_image.image_tags, 0)}"
}
