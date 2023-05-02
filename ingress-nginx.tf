## https://github.com/kubernetes/ingress-nginx/tree/master/charts/ingress-nginx

locals {
  ingress_nginx_nlb_name = "ingress-nginx-nlb"

  default_ingress_nginx_helm_config = {
    name                   = "ingress-nginx"
    repository             = "https://kubernetes.github.io/ingress-nginx"
    helm_release_name      = "ingress-nginx"
    chart_version          = "v4.6.0"
    namespace              = "ingress-nginx"    
  }

  ingress_nginx_helm_config = merge(
    local.default_ingress_nginx_helm_config,
    var.ingress_nginx_helm_config
  )

  ingress_nginx_config = templatefile(
    "${path.module}/files/ingress-nginx/values.yaml",
    {
      vpc_cidr_block = var.vpc_cidr_block
      aws_load_balancer_name = local.ingress_nginx_nlb_name
    }
  )
}

resource "kubernetes_namespace" "ingress_nginx" {
  count = try(local.ingress_nginx_helm_config["create_namespace"], true) && local.ingress_nginx_helm_config["namespace"] != "kube-system" && var.enable_ingress_nginx ? 1 : 0

  metadata {
    name = local.ingress_nginx_helm_config["namespace"]
  }
}

resource "helm_release" "ingress_nginx" {
  count = var.enable_ingress_nginx ? 1 : 0

  name       = local.ingress_nginx_helm_config.name
  repository = local.ingress_nginx_helm_config.repository
  chart      = local.ingress_nginx_helm_config.helm_release_name
  namespace  = local.ingress_nginx_helm_config.namespace
  version    = local.ingress_nginx_helm_config.chart_version

  values = [local.ingress_nginx_config]

  depends_on = [kubernetes_namespace.ingress_nginx]
}

data "aws_lb" "ingress_nginx" {
  count = var.enable_ingress_nginx ? 1 : 0

  tags = {
    "name" = local.ingress_nginx_nlb_name
  }

  depends_on = [helm_release.ingress_nginx]
}
