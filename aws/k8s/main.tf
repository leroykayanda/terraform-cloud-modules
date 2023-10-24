/* module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${var.env}-${var.cluster_name}"
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_groups = {
    green = var.nodegroup_properties
  }

  # aws-auth configmap
  create_aws_auth_configmap = false
  manage_aws_auth_configmap = true

  aws_auth_users = var.users

  tags = {
    Environment = var.env
    Team        = var.team
  }
} */


