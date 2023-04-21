locals {
  serviceaccount_name = "aws-node-termination-handler"
}

module "node_termination_handler_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.17"

  role_name                              = "node-termination-handler"
  attach_node_termination_handler_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = [
        "${var.namespace}:${var.helm_release_name}"
      ]
    }
  }
}

resource "helm_release" "aws_node_termination_handler" {
  name       = var.helm_release_name
  repository = "https://aws.github.io/eks-charts/"
  chart      = var.helm_release_name
  namespace  = var.namespace
  version    = var.chart_version

  values = [templatefile(
    "${path.module}/files/values.yaml",
    {
      serviceaccount_name = local.serviceaccount_name
      iam_role_arn        = module.node_termination_handler_irsa_role.iam_role_arn
    }
  )]
}
