locals {
  tagString = join(",", [for k, v in var.aws_tags : "${k}=${v}"])
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    labels = {
      name = var.namespace
    }

    name = var.namespace
  }
}

resource "helm_release" "ingress_nginx_release" {
  name       = var.helm_release_name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = var.namespace
  version    = var.chart_version

  values = [templatefile(
    "${path.module}/files/values.yml",
    {
      tags_string            = local.tagString
      aws_load_balancer_name = var.nlb_name
    }
  )]

  depends_on = [kubernetes_namespace.namespace]
}

data "aws_lb" "lb_ingress_nginx" {
  name       = var.nlb_name
  depends_on = [helm_release.ingress_nginx_release]
}
