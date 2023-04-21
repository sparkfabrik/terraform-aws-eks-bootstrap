resource "helm_release" "cluster_autoscaler" {
  name       = var.helm_release_name
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = var.namespace
  version    = var.chart_version

  values = [templatefile(
    "${path.module}/files/values.yaml",
    {
      iam_role_arn   = var.iam_role_arn
      cluster_name   = var.cluster_name
      cluster_region = var.cluster_region
      cpu_threshold  = var.cpu_threshold
    }
    )
  ]
}
