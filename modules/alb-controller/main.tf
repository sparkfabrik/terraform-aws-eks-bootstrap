data "aws_caller_identity" "current" {}

locals {
  serviceaccount_name = "aws-load-balancer-controller"
}

module "load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.17"

  role_name                              = local.serviceaccount_name
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.namespace}:${local.serviceaccount_name}"]
    }
  }
}

resource "helm_release" "aws_load_balancer_controller_release" {
  repository = "https://aws.github.io/eks-charts"
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  version    = var.chart_version
  namespace  = var.namespace  
  
  values = [templatefile(
    "${path.module}/files/values.yaml",
    {
      serviceaccount_name = local.serviceaccount_name
      cluster_name        = var.cluster_name
      cluster_region      = var.cluster_region
      vpc_id              = var.vpc_id
      account_id          = data.aws_caller_identity.current.account_id
      iam_role_arn        = module.load_balancer_controller_irsa_role.iam_role_arn
    }
    )
  ]
}
