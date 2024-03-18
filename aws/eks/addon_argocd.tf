resource "kubernetes_namespace" "ns" {
  count = var.cluster_created ? 1 : 0
  metadata {
    name = "argocd"
  }
}

#argo helm chart
resource "helm_release" "argocd" {
  count      = var.cluster_created ? 1 : 0
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "6.7.2"

  set {
    name  = "server.service.type"
    value = "NodePort"
  }

  set {
    name  = "notifications.secret.create"
    value = false
  }

  set {
    name  = "notifications.cm.create"
    value = false
  }

  set {
    name  = "notifications.containerPorts.metrics"
    value = 9002
  }

  values = [
    <<EOT
configs:
  cm:
    "timeout.reconciliation": "60s"
EOT
  ]
}

#ingress dns name

resource "aws_route53_record" "ingress-elb" {
  count   = var.cluster_created ? 1 : 0
  zone_id = var.argo_zone_id
  name    = var.argo_domain_name
  type    = "A"

  alias {
    name                   = var.argo_lb_dns_name
    zone_id                = var.argo_lb_zone_id
    evaluate_target_health = false
  }
}

#ingress

#kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
resource "kubernetes_ingress_v1" "ingress" {
  count = var.cluster_created ? 1 : 0
  metadata {
    name      = "argocd"
    namespace = "argocd"
    annotations = {
      "alb.ingress.kubernetes.io/backend-protocol"         = "HTTPS"
      "alb.ingress.kubernetes.io/listen-ports"             = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/ssl-redirect"             = "443"
      "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
      "alb.ingress.kubernetes.io/load-balancer-name"       = "${var.env}-eks-cluster"
      "alb.ingress.kubernetes.io/subnets"                  = "${var.argo_subnets}"
      "alb.ingress.kubernetes.io/certificate-arn"          = "${var.certificate_arn}"
      "alb.ingress.kubernetes.io/load-balancer-attributes" = var.argo_load_balancer_attributes
      "alb.ingress.kubernetes.io/target-group-attributes"  = var.argo_target_group_attributes
      "alb.ingress.kubernetes.io/tags"                     = var.argo_tags
      "alb.ingress.kubernetes.io/group.name"               = var.env
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = var.argo_domain_name

      http {
        path {
          path = "/*"

          backend {
            service {
              name = "argo-cd-argocd-server"
              port {
                number = 443
              }
            }
          }

        }
      }
    }

    tls {
      hosts = [var.argo_domain_name]
    }
  }
}

#argo ssh auth

resource "kubernetes_secret" "argo-secret" {
  count = var.cluster_created ? 1 : 0
  metadata {
    name      = "private-repo"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }

  type = "Opaque"

  data = {
    "type"          = "git"
    "url"           = var.argo_repo
    "sshPrivateKey" = var.argo_ssh_private_key
  }
}
