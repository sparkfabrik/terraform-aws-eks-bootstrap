## https://artifacthub.io/packages/helm/aws/aws-node-termination-handler

locals {
  node_termination_handler = {
    serviceaccount_name = "aws-node-termination-handler"
    chart_version     = "0.21.0"
    namespace         = "kube-system"
    helm_release_name = "aws-node-termination-handler"    
  }
}

module "node_termination_handler_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.17"

  role_name                              = "node-termination-handler"
  attach_node_termination_handler_policy = true

  oidc_providers = {
    ex = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "${local.node_termination_handler.namespace}:${local.node_termination_handler.helm_release_name}"
      ]
    }
  }
}

resource "helm_release" "aws_node_termination_handler" {
  name       = local.node_termination_handler.helm_release_name
  repository = "https://aws.github.io/eks-charts/"
  chart      = local.node_termination_handler.helm_release_name
  namespace  = local.node_termination_handler.namespace
  version    = local.node_termination_handler.chart_version

  values = [templatefile(
    "${path.module}/files/node-terminantion-handler/values.yaml",
    {
      serviceaccount_name = local.node_termination_handler.serviceaccount_name
      iam_role_arn        = module.node_termination_handler_irsa_role.iam_role_arn
    }
  )]
}
