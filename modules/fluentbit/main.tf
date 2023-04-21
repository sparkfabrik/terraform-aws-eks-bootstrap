data "aws_eks_cluster" "current" {
  name = var.cluster_name
}

resource "kubernetes_namespace" "cloudwatch_fluentbit" {
  metadata {
    labels = {
      name = var.namespace
    }

    name = var.namespace
  }
}
