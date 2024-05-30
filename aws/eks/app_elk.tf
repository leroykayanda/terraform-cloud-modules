# elk namespace

resource "kubernetes_namespace" "elk" {
  count = var.cluster_created && var.logs_type == "elk" ? 1 : 0
  metadata {
    name = "elk"
  }
}

# elasticsearch

resource "helm_release" "elastic" {
  count      = var.cluster_created && var.logs_type == "elk" ? 1 : 0
  name       = "elasticsearch"
  chart      = "elasticsearch"
  version    = "8.5.1"
  repository = "https://helm.elastic.co"
  namespace  = "elk"

  set {
    name  = "replicas"
    value = var.elastic["replicas"]
  }

  set {
    name  = "minimumMasterNodes"
    value = var.elastic["minimumMasterNodes"]
  }

  set {
    name  = "volumeClaimTemplate.resources.requests.storage"
    value = var.elastic["pv_storage"]
  }

  set {
    name  = "createCert"
    value = "true"
  }

  set {
    name  = "protocol"
    value = "https"
  }

  set {
    name  = "secret.password"
    value = var.elastic_password
  }

  values = [
    <<EOF
    esConfig: 
      elasticsearch.yml: |
        xpack.security.enabled: true
    resources: 
      requests:
        cpu: "500m"
        memory: "1Gi"
      limits:
        cpu: "1000m"
        memory: "2Gi"
    EOF
  ]

  depends_on = [
    kubernetes_namespace.elk
  ]

}

# kibana dns name

resource "aws_route53_record" "kibana" {
  count   = var.cluster_created && var.logs_type == "elk" ? 1 : 0
  zone_id = var.zone_id
  name    = var.kibana["dns_name"]
  type    = "A"

  alias {
    name                   = data.aws_lb.ingress[0].dns_name
    zone_id                = data.aws_lb.ingress[0].zone_id
    evaluate_target_health = false
  }
}

# kibana helm chart

resource "helm_release" "kibana" {
  count      = var.cluster_created && var.logs_type == "elk" ? 1 : 0
  name       = "kibana"
  chart      = "kibana"
  version    = "8.5.1"
  repository = "https://helm.elastic.co"
  namespace  = "elk"

  set {
    name  = "elasticsearchHosts"
    value = "https://elasticsearch-master.elk:9200"
  }

  set {
    name  = "automountToken"
    value = false
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  values = [
    <<EOF
    resources: 
      requests:
        cpu: "500m"
        memory: "1Gi"
      limits:
        cpu: "1000m"
        memory: "2Gi"
    EOF
  ]

  depends_on = [
    helm_release.elastic
  ]

}

# kibana ingress

resource "kubernetes_ingress_v1" "kibana" {
  count = var.cluster_created && var.logs_type == "elk" ? 1 : 0
  metadata {
    name      = "kibana"
    namespace = "elk"
    annotations = {
      "alb.ingress.kubernetes.io/backend-protocol"         = "HTTP"
      "alb.ingress.kubernetes.io/listen-ports"             = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/ssl-redirect"             = "443"
      "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
      "alb.ingress.kubernetes.io/load-balancer-name"       = "${var.env}-eks-cluster"
      "alb.ingress.kubernetes.io/subnets"                  = "${var.public_ingress_subnets}"
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
      host = var.kibana["dns_name"]

      http {
        path {
          path = "/*"

          backend {
            service {
              name = "kibana-kibana"
              port {
                number = 5601
              }
            }
          }

        }
      }
    }

    tls {
      hosts = [var.kibana["dns_name"]]
    }
  }
}
