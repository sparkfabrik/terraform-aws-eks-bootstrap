## https://github.com/kubernetes-sigs/metrics-server/blob/master/charts/metrics-server/Chart.yaml
locals {
  default_metric_server_helm_config = {
    name              = "metrics-server"
    repository        = "https://kubernetes-sigs.github.io/metrics-server"
    helm_release_name = "metrics-server"
    chart_version     = var.metric_server_chart_version
    namespace         = "kube-system"
  }

  metric_server_helm_config = merge(
    local.default_metric_server_helm_config,
    var.metric_server_helm_config
  )
}

resource "kubernetes_namespace" "metric_server" {
  count = try(local.metric_server_helm_config["create_namespace"], true) && local.metric_server_helm_config["namespace"] != "kube-system" && var.enable_metric_server ? 1 : 0

  metadata {
    name = local.metric_server_helm_config["namespace"]
  }
}

resource "helm_release" "metric_server" {
  count = var.enable_metric_server ? 1 : 0

  name       = local.metric_server_helm_config.helm_release_name
  repository = local.metric_server_helm_config.repository
  chart      = local.metric_server_helm_config.helm_release_name
  namespace  = local.metric_server_helm_config.namespace
  version    = local.metric_server_helm_config.chart_version

  values = [
    file("${path.module}/files/metric-server/values.yaml")
  ]

  depends_on = [
    module.eks
  ]
}
