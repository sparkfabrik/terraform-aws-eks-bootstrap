# Kube prometheus stack
# https://github.com/sparkfabrik/terraform-sparkfabrik-prometheus-stack
# https://github.com/prometheus-community/helm-charts/tree/kube-prometheus-stack-54.2.2/charts/kube-prometheus-stack
locals {
  kube_prometheus_namespace           = "prometheus"
  kube_prometheus_stack_chart_version = "54.2.2"
  storage_class_name                  = "prometheus-sc"

  prometheus_stack_additional_values = concat(
    [
      templatefile(
        "${path.module}/files/kube-prometheus-stack/values.yaml",
        {
          storage_class_name = local.storage_class_name
          grafana_hostname   = var.kube_prometheus_grafana_hostname
        }
      )
    ],
    var.prometheus_stack_additional_values
  )
}

resource "kubernetes_manifest" "ebs_storageclass" {
  count = var.enable_kube_prometheus_stack ? 1 : 0

  manifest = {
    "apiVersion" = "storage.k8s.io/v1"
    "kind"       = "StorageClass"
    "metadata" = {
      "name" = local.storage_class_name
    }
    "parameters" = {
      "csi.storage.k8s.io/fstype" = "xfs"
      "encrypted"                 = "false"
      "type"                      = "gp3"
    }
    "provisioner"       = "ebs.csi.aws.com"
    "volumeBindingMode" = "WaitForFirstConsumer"

    # The allowedTopologies restrict the node topologies where volumes can be dynamically provisioned.
    # This configuration is useful to be sure that the volumes are created in the same AZ of the nodes
    # dedicated to the monitoring stack.
    "allowedTopologies" = [
      {
        "matchLabelExpressions" = [
          {
            "key"    = "topology.ebs.csi.aws.com/zone"
            "values" = var.kube_prometheus_storage_zone
          },
        ]
      },
    ]
  }
}

module "kube_prometheus_stack" {
  count = var.enable_kube_prometheus_stack ? 1 : 0

  source = "github.com/sparkfabrik/terraform-sparkfabrik-prometheus-stack?ref=3.0.0"

  prometheus_stack_chart_version      = local.kube_prometheus_stack_chart_version
  namespace                           = local.kube_prometheus_namespace
  create_namespace                    = true
  grafana_ingress_host                = var.kube_prometheus_grafana_hostname
  grafana_ingress_basic_auth_username = "admin"
  regcred                             = ""
  grafana_cluster_issuer_name         = local.cert_manager_cluster_issuer_name
  grafana_ingress_basic_auth_message  = "Restricted Access"

  prometheus_stack_additional_values = local.prometheus_stack_additional_values

  depends_on = [kubernetes_manifest.ebs_storageclass]
}
