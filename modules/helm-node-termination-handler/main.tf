locals {
  serviceaccount_name = "aws-node-termination-handler"
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
      iam_role_arn        = var.iam_role_arn
      cluster_name        = var.cluster_name
      cluster_region      = var.cluster_region
    }
    )
  ]
}
