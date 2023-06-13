# Kube prometheus stack
# https://github.com/sparkfabrik/terraform-sparkfabrik-prometheus-stack
locals {
  # https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
  kube_prometheus_namespace           = "prometheus"
  kube_prometheus_stack_chart_version = "46.4.0"
  storage_class_name                  = "${local.kube_prometheus_namespace}-sc"
}

module "kube_prometheus_stack" {
  count = var.enable_kube_prometheus_stack ? 1 : 0

  source = "github.com/sparkfabrik/terraform-sparkfabrik-prometheus-stack?ref=cd54564"

  prometheus_stack_chart_version      = local.kube_prometheus_stack_chart_version
  create_namespace                    = true
  namespace                           = local.kube_prometheus_namespace
  grafana_ingress_host                = var.kube_prometheus_grafana_hostname
  grafana_ingress_basic_auth_username = "admin"
  regcred                             = ""
  grafana_cluster_issuer_name         = local.cert_manager_cluster_issuer_name
  grafana_ingress_basic_auth_message  = "Restricted Access"

  prometheus_stack_additional_values = templatefile(
    "${path.module}/files/kube-prometheus-stack/values.yaml",
    {
      storage_class_name = local.storage_class_name
      grafana_hostname = var.kube_prometheus_grafana_hostname
    }
  )

  depends_on = [ kubernetes_manifest.ebs_storageclass ]
}

resource "kubernetes_manifest" "ebs_storageclass" {
  count = var.enable_kube_prometheus_stack ? 1 : 0

  manifest = {
    "allowedTopologies" = [
      {
        "matchLabelExpressions" = [
          {
            "key" = "topology.ebs.csi.aws.com/zone"
            "values" = var.kube_prometheus_storage_zone
          },
        ]
      },
    ]
    "apiVersion" = "storage.k8s.io/v1"
    "kind" = "StorageClass"
    "metadata" = {
      "name" = local.storage_class_name
    }
    "parameters" = {
      "csi.storage.k8s.io/fstype" = "xfs"
      "encrypted" = "false"
      "type" = "gp3"
    }
    "provisioner" = "ebs.csi.aws.com"
    "volumeBindingMode" = "WaitForFirstConsumer"
  }
}
