locals {
  serviceaccount_name = "aws-load-balancer-controller"
}

resource "helm_release" "aws_load_balancer_controller_release" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = var.namespace
  version    = var.chart_version
  values = [templatefile(
    "${path.module}/files/values.yaml",
    {
      serviceaccount_name = local.serviceaccount_name
      cluster_name        = var.cluster_name
      cluster_region      = var.cluster_region
      vpc_id              = var.vpc_id
      account_id          = var.account_id
      iam_role_arn        = var.iam_role_arn
    }
    )
  ]
}
