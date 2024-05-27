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
  version    = "6.11.1"

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

data "aws_lb" "ingress" {
  count      = var.cluster_created ? 1 : 0
  name       = "${var.env}-eks-cluster"
  depends_on = [kubernetes_ingress_v1.ingress]
}

resource "aws_route53_record" "ingress-elb" {
  count   = var.cluster_created ? 1 : 0
  zone_id = var.zone_id
  name    = var.argocd["dns_name"]
  type    = "A"

  alias {
    name                   = data.aws_lb.ingress[0].dns_name
    zone_id                = data.aws_lb.ingress[0].zone_id
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
      "alb.ingress.kubernetes.io/load-balancer-attributes" = var.argocd["load_balancer_attributes"]
      "alb.ingress.kubernetes.io/target-group-attributes"  = var.argocd["target_group_attributes"]
      "alb.ingress.kubernetes.io/tags"                     = var.argocd["tags"]
      "alb.ingress.kubernetes.io/group.name"               = var.env
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = var.argocd["dns_name"]

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
      hosts = [var.argocd["dns_name"]]
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
    "url"           = var.argocd["repo"]
    "sshPrivateKey" = var.argo_ssh_private_key
  }
}

#argo notifications secret

resource "kubernetes_secret" "argocd_notifications_secret" {
  count = var.cluster_created ? 1 : 0
  metadata {
    name      = "argocd-notifications-secret"
    namespace = "argocd"
  }

  data = {
    "slack-token" = var.argo_slack_token
  }

  type = "Opaque"
}

#argo notifications

resource "kubernetes_config_map" "argocd_notifications_cm" {
  count = var.cluster_created ? 1 : 0
  metadata {
    name      = "argocd-notifications-cm"
    namespace = "argocd"
  }

  data = {
    "service.slack" = <<-EOT
      token: $slack-token
    EOT

    "context" = <<-EOT
      argocdUrl: https://${var.argocd["dns_name"]}
    EOT

    "trigger.on-health-degraded" = <<-EOT
      - when: app.status.health.status == 'Degraded' || app.status.health.status == 'Missing' || app.status.health.status == 'Unknown'
        send: [app-degraded]
    EOT

    "template.app-degraded" = <<-EOT
      message: |
        ArgoCD - Application {{.app.metadata.name}} is {{.app.status.health.status}}.
      slack:
        attachments: |
          [{
            "title": "{{.app.metadata.name}}",
            "title_link": "{{.context.argocdUrl}}/applications/argocd/{{.app.metadata.name}}",
            "color": "#ff0000",
            "fields": [{
              "title": "App Health",
              "value": "{{.app.status.health.status}}",
              "short": true
            }, {
              "title": "Repository",
              "value": "{{.app.spec.source.repoURL}}",
              "short": true
            }]
          }]
    EOT
  }
}

#image updater

resource "helm_release" "image_updater" {
  count      = var.cluster_created ? 1 : 0
  name       = "argocd-image-updater"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"
  namespace  = "argocd"
  version    = "0.9.2"
  values     = var.argocd_image_updater_values
}
