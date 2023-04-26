# https://github.com/aws/eks-charts/tree/master/stable/aws-for-fluent-bit

# resource "kubernetes_namespace" "namespace" {
#   metadata {
#     annotations = {}
#     labels      = {}
#     name        = var.namespace
#   }
# }

# resource "helm_release" "fluent_bit" {
#   repository = "https://aws.github.io/eks-charts"
#   name       = "fluent-bit"
#   chart      = "aws-for-fluent-bit"
#   version    = var.chart_version
#   namespace  = var.namespace

#   set {
#     name  = "cloudWatchLogs.region"
#     value = "eu-west-1"
#   }
# }
