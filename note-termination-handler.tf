## https://github.com/aws/eks-charts/tree/master/stable/aws-node-termination-handler

locals {
  default_aws_node_termination_handler_helm_config = {
    repository          = "https://aws.github.io/eks-charts/"
    serviceaccount_name = "aws-node-termination-handler"
    chart_version       = "0.21.0"
    namespace           = "kube-system"
    helm_release_name   = "aws-node-termination-handler"
  }

  aws_node_termination_handler_helm_config = merge(
    local.default_aws_node_termination_handler_helm_config,
    var.aws_node_termination_handler_helm_config
  )
}

resource "kubernetes_namespace" "aws_node_termination_handler" {
  count = try(local.aws_node_termination_handler_helm_config["create_namespace"], true) && local.aws_node_termination_handler_helm_config["namespace"] != "kube-system" ? 1 : 0

  metadata {
    labels = {
      name = local.aws_node_termination_handler_helm_config["namespace"]
    }

    name = local.aws_node_termination_handler_helm_config["namespace"]
  }
  depends_on = [module.eks]
}

module "node_termination_handler_irsa_role" {
  count = var.enable_aws_node_termination_handler ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.17"

  role_name                              = "node-termination-handler"
  attach_node_termination_handler_policy = true

  oidc_providers = {
    ex = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "${local.aws_node_termination_handler_helm_config.namespace}:${local.aws_node_termination_handler_helm_config.helm_release_name}"
      ]
    }
  }
}

resource "helm_release" "aws_node_termination_handler" {
  count      = var.enable_aws_node_termination_handler ? 1 : 0

  name       = local.aws_node_termination_handler_helm_config.helm_release_name
  repository = local.aws_node_termination_handler_helm_config.repository
  chart      = local.aws_node_termination_handler_helm_config.helm_release_name
  namespace  = local.aws_node_termination_handler_helm_config.namespace
  version    = local.aws_node_termination_handler_helm_config.chart_version

  values = [templatefile(
    "${path.module}/files/node-terminantion-handler/values.yaml",
    {
      serviceaccount_name = local.aws_node_termination_handler_helm_config.serviceaccount_name
      iam_role_arn        = module.node_termination_handler_irsa_role[0].iam_role_arn
    }
  )]

  depends_on = [
    module.eks, kubernetes_namespace.aws_node_termination_handler
  ]
}
