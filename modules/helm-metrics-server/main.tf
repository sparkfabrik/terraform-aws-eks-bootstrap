resource "helm_release" "metric_server" {
  name       = var.helm_release_name
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  namespace  = var.namespace
  version    = var.chart_version

  values = [templatefile(
    "${path.module}/files/values.yaml",
    {}
  )]
  depends_on = [
    kubernetes_namespace.namespace
  ]
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations = {}
    labels      = {}
    name        = var.namespace
  }
}
