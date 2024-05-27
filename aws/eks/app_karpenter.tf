resource "helm_release" "karpenter" {
  count      = var.cluster_created && var.autoscaling_type == "karpenter" ? 1 : 0
  name       = "karpenter"
  repository = "https://charts.karpenter.sh/"
  chart      = "karpenter"
  namespace  = "kube-system"
  version    = "0.16.3"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "clusterEndpoint"
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

resource "aws_iam_role_policy_attachment" "karpenter" {
  count      = var.cluster_created && var.autoscaling_type == "karpenter" ? 1 : 0
  role       = aws_iam_role.karpenter[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSKarpenterControllerPolicy"
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

