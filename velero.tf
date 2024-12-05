# Velero
# https://github.com/vmware-tanzu/helm-charts/tree/main/charts/velero
# https://github.com/vmware-tanzu/velero-plugin-for-aws
# https://hub.docker.com/r/velero/velero-plugin-for-aws/tags?page=1&ordering=last_updated
# https://hub.docker.com/r/velero/velero-plugin-for-csi/tags?page=1&ordering=last_updated

locals {
  default_velero_helm_config = {
    name               = "velero"
    repository         = "https://vmware-tanzu.github.io/helm-charts"
    helm_release_name  = "velero"
    chart_version      = var.velero_chart_version
    namespace          = "velero"
    create_namespace   = true
    aws_plugin_version = "v1.9.1"
    schedule_cron      = var.velero_schedule_cron
  }

  velero_helm_config = merge(
    local.default_velero_helm_config,
    var.velero_helm_config
  )

  # Add a random suffix to prevent bucket name collisions.
  bucket_name = "${var.cluster_name}-velero-storage-${random_id.resources_suffix[0].hex}"

  velero_default_values = templatefile(
    "${path.module}/files/velero/values.yaml", {
      role_arn              = module.velero_irsa_role[0].iam_role_arn
      bucket                = local.bucket_name
      serviceaccount_name   = local.velero_helm_config.name
      aws_container_version = local.velero_helm_config.aws_plugin_version
      region                = data.aws_region.current.name
      schedule_cron         = local.velero_helm_config.schedule_cron
    }
  )
}

# The generated random_id is 4 characters long.
resource "random_id" "resources_suffix" {
  count       = var.enable_velero ? 1 : 0
  byte_length = 2
}

resource "kubernetes_namespace" "velero" {
  count = local.velero_helm_config.create_namespace && var.enable_velero ? 1 : 0

  metadata {
    name = local.velero_helm_config.namespace
  }
}

resource "aws_s3_bucket" "velero" {
  count = var.enable_velero ? 1 : 0

  bucket        = local.bucket_name
  force_destroy = false

  tags = {
    Cluster = var.cluster_name
  }
}

resource "aws_s3_bucket_versioning" "velero" {
  count = var.enable_velero ? 1 : 0

  bucket = aws_s3_bucket.velero[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "velero" {
  count = var.enable_velero ? 1 : 0

  bucket                  = aws_s3_bucket.velero[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "velero" {
  count  = var.enable_velero && var.enable_velero_bucket_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.velero[0].id

  rule {
    id     = "dumps"
    status = "Enabled"
    transition {
      days          = var.velero_bucket_infrequently_access_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.velero_bucket_glacier_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.velero_bucket_expiration_days
    }
  }
}


module "velero_irsa_role" {
  count = var.enable_velero ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.20"

  role_name             = "${local.velero_helm_config.name}-irsa-role"
  attach_velero_policy  = true
  velero_s3_bucket_arns = ["arn:aws:s3:::${local.bucket_name}"]
  oidc_providers = {
    ex = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "${local.velero_helm_config.namespace}:${local.velero_helm_config.name}"
      ]
    }
  }

  tags = {
    Cluster = var.cluster_name
  }
}

resource "helm_release" "velero" {
  count = var.enable_velero ? 1 : 0

  name       = local.velero_helm_config.name
  repository = local.velero_helm_config.repository
  chart      = local.velero_helm_config.helm_release_name
  namespace  = local.velero_helm_config.namespace
  version    = local.velero_helm_config.chart_version

  values = trimspace(var.velero_helm_values) != "" ? [local.velero_default_values.template, var.velero_helm_values] : [local.velero_default_values.template]

  depends_on = [
    kubernetes_namespace.velero
  ]
}
