module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8.3"

  cluster_name                             = var.cluster_name
  cluster_version                          = var.cluster_version
  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  vpc_id                                   = var.vpc_id
  subnet_ids                               = var.private_subnets
  authentication_mode                      = "API_AND_CONFIG_MAP"
  cloudwatch_log_group_retention_in_days   = 30
  enable_cluster_creator_admin_permissions = true
  access_entries                           = var.access_entries

  cluster_addons = {
    coredns = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }

    aws-ebs-csi-driver = {
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
    initial-nodegroup  = var.initial_nodegroup
    critical-nodegroup = var.critical_nodegroup
  }

  tags = {
    Environment                                 = var.env
    Team                                        = var.team
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

module "access_log_bucket" {
  source            = "../aws-alb-access-log-bucket"
  env               = var.env
  team              = var.team
  microservice_name = "${var.company_name}-eks-cluster"
}

