## https://github.com/kubernetes/ingress-nginx/tree/master/charts/ingress-nginx

locals {
  ingress_nginx_nlb_name = "ingress-nginx-nlb"

  default_ingress_nginx_helm_config = {
    name              = "ingress-nginx"
    repository        = "https://kubernetes.github.io/ingress-nginx"
    helm_release_name = "ingress-nginx"
    namespace         = "ingress-nginx"
  }

  ingress_nginx_helm_config = merge(
    local.default_ingress_nginx_helm_config,
    var.ingress_nginx_helm_config
  )

  ingress_nginx_config = templatefile(
    "${path.module}/files/ingress-nginx/values.yaml",
    {
      vpc_cidr_block         = var.vpc_cidr_block
      aws_load_balancer_name = local.ingress_nginx_nlb_name
    }
  )
}

module "ingress_nginx" {
  source            = "github.com/sparkfabrik/terraform-helm-ingress-nginx?ref=0.8.0"
  namespace         = local.ingress_nginx_helm_config.namespace
  helm_release_name = local.ingress_nginx_helm_config.helm_release_name

  additional_values = [local.ingress_nginx_config]
}

data "aws_lb" "ingress_nginx" {
  count = var.enable_ingress_nginx ? 1 : 0

  tags = {
    "name" = local.ingress_nginx_nlb_name
  }

  depends_on = [module.ingress_nginx]
}
