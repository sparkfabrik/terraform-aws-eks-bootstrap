## https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller

locals {
  default_aws_alb_controller_helm_config = {
    repository          = "https://aws.github.io/eks-charts/"
    serviceaccount_name = "aws-load-balancer-controller"
    chart_version       = "1.5.2"
    namespace           = "kube-system"
    helm_release_name   = "aws-load-balancer-controller"
  }

  aws_alb_controller_helm_config = merge(
    local.default_aws_alb_controller_helm_config,
    var.aws_alb_controller_helm_config
  )
}

resource "kubernetes_namespace" "aws_load_balancer_controller" {
  count = try(local.aws_alb_controller_helm_config["create_namespace"], true) && local.aws_alb_controller_helm_config["namespace"] != "kube-system" ? 1 : 0

  metadata {
    labels = {
      name = local.aws_alb_controller_helm_config["namespace"]
    }

    name = local.aws_alb_controller_helm_config["namespace"]
  }

  depends_on = [module.eks]
}

module "load_balancer_controller_irsa_role" {
  count      = var.enable_aws_alb_controller ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.17"

  role_name                              = "load-balancer-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${local.aws_alb_controller_helm_config.namespace}:${local.aws_alb_controller_helm_config.helm_release_name}"]
    }
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  count      = var.enable_aws_alb_controller ? 1 : 0

  name       = local.aws_alb_controller_helm_config.helm_release_name
  repository = local.aws_alb_controller_helm_config.repository
  chart      = local.aws_alb_controller_helm_config.helm_release_name
  namespace  = local.aws_alb_controller_helm_config.namespace
  version    = local.aws_alb_controller_helm_config.chart_version

  values = [templatefile(
    "${path.module}/files/aws-alb-controller/values.yaml",
    {
      serviceaccount_name = local.aws_alb_controller_helm_config.serviceaccount_name
      cluster_name        = var.cluster_name
      cluster_region      = data.aws_region.current.name
      vpc_id              = var.vpc_id
      account_id          = data.aws_caller_identity.current.account_id
      iam_role_arn        = module.load_balancer_controller_irsa_role[0].iam_role_arn
    }
    )
  ]
  depends_on = [
    module.eks,
    module.load_balancer_controller_irsa_role
  ]
}
