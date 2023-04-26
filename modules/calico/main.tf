
locals {
  namespace = "tigera-operator"
}

resource "kubernetes_namespace" "calico" {
  metadata {
    name = local.namespace
  }
}

resource "helm_release" "calico" {
  repository = "https://docs.tigera.io/calico/charts"
  chart      = "tigera-operator"
  name       = "tigera-operator"
  version    = var.chart_version
  namespace  = local.namespace

  values = [templatefile(
    "${path.module}/files/values.yaml",
    {}
  )]
}