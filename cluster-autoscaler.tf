## https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler
locals {
  cluster_autoscaler = {
    name              = "cluster-autoscaler"
    repository        = "https://kubernetes.github.io/autoscaler" 
    helm_release_name = "cluster-autoscaler"
    chart_version     = "9.28.0"
    namespace         = "kube-system"
  }
}

module "cluster_autoscaler_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.17"

  role_name                        = "cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [var.cluster_name]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${local.cluster_autoscaler.namespace}:${local.cluster_autoscaler.helm_release_name}-aws-cluster-autoscaler"]
    }
  }
}

resource "helm_release" "cluster_autoscaler" {
  name       = local.cluster_autoscaler.helm_release_name
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = local.cluster_autoscaler.namespace
  version    = local.cluster_autoscaler.chart_version

  values = [templatefile(
    "${path.module}/files/cluster-autoscaler/values.yaml",
    {
      iam_role_arn   = module.cluster_autoscaler_irsa_role.iam_role_arn
      cluster_name   = var.cluster_name
      cluster_region = data.aws_region.current.name
    }
  )]

  depends_on = [
    
  ]
}
