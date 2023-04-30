locals {
  calico   = {
    namespace = "tigera-operator"
    chart_version = "3.25.1"
  }
}

resource "kubernetes_namespace" "calico" {
  metadata {
    name = local.calico.namespace
  }
}

resource "helm_release" "calico" {
  repository = "https://docs.tigera.io/calico/charts"
  chart      = "tigera-operator"
  name       = "tigera-operator"
  version    = local.calico.chart_version
  namespace  = local.calico.namespace

  values = [templatefile(
    "${path.module}/files/calico/values.yaml",
    {}
  )]
}
