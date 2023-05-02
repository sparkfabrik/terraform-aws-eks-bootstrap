locals {
  default_calico_helm_config = {
    name              = "tigera-operator"
    repository        = "https://docs.tigera.io/calico/charts"
    helm_release_name = "tigera-operator"
    chart_version     = "v3.25.1"
    namespace         = "tigera-operator"
  }

  calico_helm_config = merge(
    local.default_calico_helm_config,
    var.calico_helm_config
  )
}

resource "kubernetes_namespace" "calico" {
  count = try(local.calico_helm_config["create_namespace"], true) && local.calico_helm_config["namespace"] != "kube-system" && var.enable_calico ? 1 : 0

  metadata {
    name = local.calico_helm_config["namespace"]
  }
}

resource "helm_release" "calico" {
  count      = var.enable_calico ? 1 : 0

  repository = local.calico_helm_config.repository
  chart      = local.calico_helm_config.helm_release_name
  name       = local.calico_helm_config.name
  version    = local.calico_helm_config.chart_version
  namespace  = local.calico_helm_config.namespace

  values = [templatefile(
    "${path.module}/files/calico/values.yaml",
    {}
  )]

  depends_on = [
    module.eks, kubernetes_namespace.calico
  ]
}
