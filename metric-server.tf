## https://github.com/kubernetes-sigs/metrics-server/blob/master/charts/metrics-server/Chart.yaml
locals {
  metric_server = {
    name              = "metrics-server"
    repository        = "https://kubernetes-sigs.github.io/metrics-server"
    helm_release_name = "metrics-server"
    chart_version     = "3.10.0"
    namespace         = "kube-system"
  }
}

resource "helm_release" "metric_server" {
  name       = local.metric_server.helm_release_name
  repository = local.metric_server.repository
  chart      = local.metric_server.helm_release_name
  namespace  = local.metric_server.namespace
  version    = local.metric_server.chart_version

  depends_on = [
    module.eks
  ]
}