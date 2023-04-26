module "cluster_autoscaler_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.17"

  role_name                        = "cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [var.cluster_name]

  oidc_providers = {
    ex = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler-aws-cluster-autoscaler"]
    }
  }
}

# Cluster Autoscaler https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler
# https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#what-are-the-parameters-to-ca
resource "helm_release" "cluster_autoscaler" {
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  name       = "cluster-autoscaler"
  version    = var.chart_version
  namespace  = "kube-system"

  values = [templatefile(
    "${path.module}/files/values.yaml",
    {
      iam_role_arn             = module.cluster_autoscaler_irsa_role.iam_role_arn
      cluster_name             = var.cluster_name
      cluster_region           = var.cluster_region
      scale_down_cpu_threshold = var.scale_down_cpu_threshold
    }
  )]
}
