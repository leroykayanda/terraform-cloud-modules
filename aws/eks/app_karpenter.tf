resource "helm_release" "karpenter" {
  count      = var.cluster_created && var.autoscaling_type == "karpenter" ? 1 : 0
  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter/karpenter"
  chart      = "karpenter"
  namespace  = "kube-system"
  version    = "v0.32.10"

  set {
    name  = "settings.aws.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.aws.clusterEndpoint"
    value = module.eks.cluster_endpoint
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = local.karpenter_sa
  }

  values = [
    <<EOF
    controller:
      resources: 
        requests:
          cpu: "100m"
          memory: "256Mi"
        limits:
          cpu: "1000m"
          memory: "1Gi"
    EOF
  ]
}


#create service account

resource "aws_iam_role" "karpenter" {
  count = var.cluster_created && var.autoscaling_type == "karpenter" ? 1 : 0
  name  = "${var.cluster_name}-${local.karpenter_sa}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.eks_oidc_issuer}"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "karpenter" {
  count  = var.cluster_created && var.autoscaling_type == "karpenter" ? 1 : 0
  name   = "${var.cluster_name}-${local.karpenter_sa}"
  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "ec2:CreateLaunchTemplate",
                "ec2:CreateFleet",
                "ec2:RunInstances",
                "ec2:CreateTags",
                "ec2:TerminateInstances",
                "ec2:DeleteLaunchTemplate",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeInstances",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeImages",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeInstanceTypeOfferings",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeSpotPriceHistory",
                "iam:PassRole",
                "ssm:GetParameter",
                "pricing:GetProducts"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "Karpenter"
        },
        {
            "Action": "ec2:TerminateInstances",
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/Name": "*karpenter*"
                }
            },
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "ConditionalEC2Termination"
        },
        {
            "Effect": "Allow",
            "Action": "eks:DescribeCluster",
            "Resource": "${module.eks.cluster_arn}",
            "Sid": "eksClusterEndpointLookup"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role_policy_attachment" "karpenter" {
  count      = var.cluster_created && var.autoscaling_type == "karpenter" ? 1 : 0
  role       = aws_iam_role.karpenter[0].name
  policy_arn = aws_iam_policy.karpenter[0].arn
}

resource "kubernetes_service_account" "karpenter" {
  count = var.cluster_created && var.autoscaling_type == "karpenter" ? 1 : 0
  metadata {
    name      = local.karpenter_sa
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.karpenter[0].arn
    }
  }
  automount_service_account_token = true
}

