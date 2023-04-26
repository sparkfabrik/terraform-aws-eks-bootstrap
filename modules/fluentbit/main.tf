data "aws_eks_cluster" "current" {
  name = var.cluster_name
}

locals {
  fluent_bit_sa_name   = "fluent-bit"
  fluent_bit_role_name = "fluent-bit-role"
  fluent_bit_namespace = "amazon-cloudwatch"
}

resource "kubernetes_namespace" "cloudwatch_fluentbit" {
  metadata {
    labels = {
      name = local.fluent_bit_namespace
    }

    name = local.fluent_bit_namespace
  }
}

data "aws_iam_policy" "CloudWatchAgentServerPolicy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

module "iam_assumable_role_with_oidc_for_fluentbit_aws" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.2.0"

  create_role = true
  role_name   = local.fluent_bit_role_name

  provider_url = flatten(concat(data.aws_eks_cluster.current.identity[*].oidc.0.issuer, [""]))[0]

  role_policy_arns = [
    data.aws_iam_policy.CloudWatchAgentServerPolicy.arn
  ]

  oidc_fully_qualified_subjects = [
    # The SA is created by the fluent-bit-ds manifest
    "system:serviceaccount:${local.fluent_bit_namespace}:${local.fluent_bit_sa_name}"
  ]
}

locals {
  cwfb_cm_values_manifest = templatefile(
    "${path.module}/files/fluent-bit-values-cm.yaml",
    {
      namespace      = local.fluent_bit_namespace
      region         = var.cluster_region
      cluster_name   = var.cluster_name
      http_server    = var.fluent_bit_http_server
      http_port      = var.fluent_bit_http_port
      read_from_head = var.fluent_bit_read_from_head
      read_from_tail = var.fluent_bit_read_from_tail
    }
  )
}

resource "kubectl_manifest" "fluent_bit_cm" {
  yaml_body = local.cwfb_cm_values_manifest
  count     = var.fluent_bit_enable_logs_collection ? 1 : 0

  depends_on = [
    kubernetes_namespace.cloudwatch_fluentbit
  ]
}

locals {
  cwfb_ds_manifest_count = length(split(
    "\n---\n",
    file("${path.module}/files/fluent-bit-ds.yaml")
  ))
  cwfb_ds_manifest = split(
    "\n---\n",
    templatefile(
      "${path.module}/files/fluent-bit-ds.yaml",
      {
        namespace  = local.fluent_bit_namespace
        image_tag  = var.fluent_bit_image_tag
        account_id = var.account_id
        iam_role   = local.fluent_bit_role_name
      }
    )
  )
}

resource "kubectl_manifest" "fluent_bit_ds" {
  count     = var.fluent_bit_enable_logs_collection ? local.cwfb_ds_manifest_count : 0
  yaml_body = local.cwfb_ds_manifest[count.index]

  depends_on = [
    kubernetes_namespace.cloudwatch_fluentbit,
    kubectl_manifest.fluent_bit_cm,
    kubectl_manifest.fluent_bit_config_file_cm
  ]
}

locals {
  cwfb_config_file_cm_manifest = split(
    "\n---\n",
    replace(
      replace(file("${path.module}/files/fluent-bit-config-file-cm.yaml"), "___namespace___", local.fluent_bit_namespace),
      "___fluent_bit_log_retention_days___", "${var.fluent_bit_log_retention_days}"
    )
  )
  cwfb_config_file_cm_manifest_count = length(local.cwfb_config_file_cm_manifest)
}

resource "kubectl_manifest" "fluent_bit_config_file_cm" {
  count     = local.cwfb_config_file_cm_manifest_count > 0 ? local.cwfb_config_file_cm_manifest_count : 0
  yaml_body = local.cwfb_config_file_cm_manifest[count.index]

  depends_on = [
    kubernetes_namespace.cloudwatch_fluentbit
  ]
}
