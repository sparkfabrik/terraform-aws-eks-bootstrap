## https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler

locals {
  default_cluster_autoscaler_helm_config = {
    name              = "cluster-autoscaler"
    repository        = "https://kubernetes.github.io/autoscaler"
    helm_release_name = "cluster-autoscaler"
    chart_version     = "9.28.0"
    namespace         = "kube-system"
  }

  cluster_autoscaler_helm_config = merge(
    local.default_cluster_autoscaler_helm_config,
    var.cluster_autoscaler_helm_config
  )
}

resource "kubernetes_namespace" "cluster_autoscaler" {
  count = try(local.cluster_autoscaler_helm_config["create_namespace"], true) && local.cluster_autoscaler_helm_config["namespace"] != "kube-system" ? 1 : 0

  metadata {
    name = local.cluster_autoscaler_helm_config["namespace"]
  }
}

module "cluster_autoscaler_irsa_role" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.17"

  role_name                        = "cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [var.cluster_name]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${local.cluster_autoscaler_helm_config.namespace}:${local.cluster_autoscaler_helm_config.helm_release_name}-aws-cluster-autoscaler"]
    }
  }
}

resource "helm_release" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  name       = local.cluster_autoscaler_helm_config.helm_release_name
  repository = local.cluster_autoscaler_helm_config.repository
  chart      = local.cluster_autoscaler_helm_config.helm_release_name
  namespace  = local.cluster_autoscaler_helm_config.namespace
  version    = local.cluster_autoscaler_helm_config.chart_version

  values = [templatefile(
    "${path.module}/files/cluster-autoscaler/values.yaml",
    {
      iam_role_arn   = module.cluster_autoscaler_irsa_role[0].iam_role_arn
      cluster_name   = var.cluster_name
      cluster_region = data.aws_region.current.name
    }
  )]

  depends_on = [
    module.eks,
    kubernetes_namespace.metric_server
  ]
}
