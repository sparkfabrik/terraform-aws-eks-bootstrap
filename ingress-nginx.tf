## https://github.com/kubernetes/ingress-nginx/tree/master/charts/ingress-nginx

locals {
  ingress_nginx_namespace     = "ingress-nginx"
  ingress_nginx_chart_version = "v4.6.0"
  ingress_nginx_nlb_name      = "ingress-nginx-nlb"
  ingress_nginx_config = templatefile(
    "${path.module}/files/ingress-nginx/values.yaml",
    {
      aws_load_balancer_name = "ingress-nginx-nlb"
    }
  )
}

resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    labels = {
      name = local.ingress_nginx_namespace
    }

    name = local.ingress_nginx_namespace
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = local.ingress_nginx_namespace
  version    = local.ingress_nginx_chart_version

  values = [local.ingress_nginx_config]

  depends_on = [kubernetes_namespace.ingress_nginx]
}

data "aws_lb" "ingress_nlb" {
  tags = {
    "name" = local.ingress_nginx_nlb_name
  }
}
