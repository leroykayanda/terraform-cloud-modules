module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.20.0"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  create_aws_auth_configmap      = false
  manage_aws_auth_configmap      = true
  aws_auth_users                 = var.users

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      before_compute = true
      most_recent    = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  eks_managed_node_groups = {
    green = var.nodegroup_properties
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

module "access_log_bucket" {
  source            = "../aws-alb-access-log-bucket"
  env               = var.env
  team              = var.team
  microservice_name = "eks-cluster"
}

