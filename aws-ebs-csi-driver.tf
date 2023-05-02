## https://github.com/kubernetes-sigs/aws-ebs-csi-driver
## https://github.com/kubernetes-sigs/aws-ebs-csi-driver/tree/master/charts/aws-ebs-csi-driver

locals {
  default_aws_ebs_csi_driver_helm_config = {
    name              = "aws-ebs-csi-driver"
    repository        = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
    helm_release_name = "aws-ebs-csi-driver"
    chart_version     = "2.18.0"
    namespace         = "kube-system"
  }

  aws_ebs_csi_driver_helm_config = merge(
    local.default_aws_ebs_csi_driver_helm_config,
    var.aws_ebs_csi_driver_helm_config
  )

  aws_ebs_csi_driver_service_account_name = "aws-ebs-csi-driver"
  aws_ebs_csi_driver_iam_policy_name      = "AmazonEKS_EBS_CSI_Driver_Policy"
  aws_ebs_csi_driver_iam_role_name        = "AmazonEKS_EBS_CSI_DriverRole"
}

resource "kubernetes_namespace" "aws_ebs_csi_driver" {
  count = try(local.aws_ebs_csi_driver_helm_config["create_namespace"], true) && local.aws_ebs_csi_driver_helm_config["namespace"] != "kube-system" && var.enable_aws_ebs_csi_driver ? 1 : 0

  metadata {
    name = local.aws_ebs_csi_driver_helm_config["namespace"]
  }
}

resource "aws_iam_policy" "aws_ebs_csi_driver" {
  count = var.enable_aws_ebs_csi_driver ? 1 : 0

  name = local.aws_ebs_csi_driver_iam_policy_name
  path = "/"
  policy = templatefile(
    "${path.module}/files/aws-ebs-csi-driver/policy.json",
    {
      cluster_id = var.cluster_name
    }
  )
}

module "aws_ebs_csi_driver_identity" {
  count = var.enable_aws_ebs_csi_driver ? 1 : 0

  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "~> 4.2"
  create_role  = true
  role_name    = local.aws_ebs_csi_driver_iam_role_name
  provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns = [
    aws_iam_policy.aws_ebs_csi_driver[0].arn
  ]

  oidc_fully_qualified_subjects = [
    # The SA is created by the helm chart
    "system:serviceaccount:${local.aws_ebs_csi_driver_helm_config.namespace}:${local.aws_ebs_csi_driver_service_account_name}"
  ]
}

resource "helm_release" "ebs" {
  count = var.enable_aws_ebs_csi_driver ? 1 : 0

  name       = local.aws_ebs_csi_driver_helm_config.name
  repository = local.aws_ebs_csi_driver_helm_config.repository
  chart      = local.aws_ebs_csi_driver_helm_config.helm_release_name
  namespace  = local.aws_ebs_csi_driver_helm_config.namespace
  version    = local.aws_ebs_csi_driver_helm_config.chart_version

  values = [
    templatefile(
      "${path.module}/files/aws-ebs-csi-driver/values.yaml",
      {
        role_arn           = module.aws_ebs_csi_driver_identity[0].iam_role_arn
        serviceaccount     = local.aws_ebs_csi_driver_service_account_name
      }
    )
  ]
}
