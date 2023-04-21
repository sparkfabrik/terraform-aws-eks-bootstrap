module "cluster_autoscaler_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.17"

  role_name                        = "cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [var.cluster_name]

  oidc_providers = {
    ex = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.namespace}:${var.helm_release_name}-aws-cluster-autoscaler"]
    }
  }
}

resource "helm_release" "cluster_autoscaler" {
  name       = var.helm_release_name
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = var.namespace
  version    = var.chart_version

  values = [templatefile(
    "${path.module}/files/values.yaml",
    {
      iam_role_arn   = module.cluster_autoscaler_irsa_role.iam_role_arn
      cluster_name   = var.cluster_name
      cluster_region = var.cluster_region
      cpu_threshold  = var.cpu_threshold
    }
  )]
}
