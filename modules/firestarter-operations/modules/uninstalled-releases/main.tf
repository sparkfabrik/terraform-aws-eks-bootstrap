terraform {
  required_version = "~> 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.19"
    }
  }
}

// -----------------------
// Data and local resources
// -----------------------
// The following is needed to retrieve the account ID for the Kubernetes service account annotation.
data "aws_caller_identity" "current" {}

locals {
  full_iam_role_name        = join("-", [var.project, var.environment, var.iam_role_name_prefix, "role"])
  full_iam_policy_name      = join("-", [var.project, var.environment, var.iam_policy_name_prefix, "policy"])
  full_service_account_name = join("-", [var.project, var.environment, var.service_account_name_prefix, "sa"])
  oidc_subjects             = [for namespace in var.namespaces : "system:serviceaccount:${namespace}:${local.full_service_account_name}"]
}

resource "aws_s3_bucket" "uninstalled_releases" {
  bucket = var.bucket_name
  acl    = "private"
  lifecycle_rule {
    enabled = var.enable_bucket_lifecycle

    transition {
      days          = var.infrequently_access_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.glacier_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.expiration_days
    }
  }
  tags = var.aws_tags
}

resource "aws_iam_policy" "uninstalled_releases" {
  name = local.full_iam_policy_name
  path = "/"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject",
            "s3:ListMultipartUploadParts",
            "s3:ListBucket"
          ],
          "Resource" : [
            "arn:aws:s3:::*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject",
            "s3:PutObject",
            "s3:AbortMultipartUpload",
            "s3:ListMultipartUploadParts"
          ],
          "Resource" : [
            "arn:aws:s3:::${var.bucket_name}/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:CreateBucket",
            "s3:ListBucket"
          ],
          "Resource" : [
            "arn:aws:s3:::${var.bucket_name}"
          ]
        }
      ]
    }
  )
  tags = var.aws_tags
}

module "iam_assumable_role_with_oidc_for_uninstalled_releases" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.0"

  create_role = true
  role_name   = local.full_iam_role_name

  tags = var.aws_tags

  provider_url = var.oidc_provider_url

  role_policy_arns = [
    aws_iam_policy.uninstalled_releases.arn
  ]

  # The SA is created by the provider_aws manifest
  oidc_fully_qualified_subjects = local.oidc_subjects
}

// Create the Kubernetes Service Account for operator-account
resource "kubernetes_service_account" "operator_account_sa" {
  for_each = toset(var.namespaces)

  metadata {
    name      = local.full_service_account_name
    namespace = each.value
    # https://docs.aws.amazon.com/eks/latest/userguide/specify-service-account-role.html
    # eks.amazonaws.com/role-arn=arn:aws:iam::<ACCOUNT_ID>:role/<IAM_ROLE_NAME>
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${module.iam_assumable_role_with_oidc_for_uninstalled_releases.iam_role_name}"
    }
  }
}
