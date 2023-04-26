# Metrics Server https://artifacthub.io/packages/helm/metrics-server/metrics-server

resource "helm_release" "metric_server" {
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  name       = "metrics-server"
  version    = var.chart_version
  namespace  = "kube-system"

  values = [templatefile(
    "${path.module}/files/values.yaml",
    {}
  )]
}
