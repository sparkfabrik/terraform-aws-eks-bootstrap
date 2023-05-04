terraform {
  required_version = "~> 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.19"
    }
  }
}

locals {
  reader_name = join("-", [var.project, var.environment, "seeds-reader"])
  admin_name  = join("-", [var.project, var.environment, "seeds-admin"])
}

resource "aws_s3_bucket" "seeds" {
  bucket = var.bucket_name
  acl    = "private"
  tags   = var.aws_tags
}

resource "aws_iam_user" "seeds_reader" {
  name = local.reader_name
  tags = var.aws_tags
}

resource "aws_iam_access_key" "seeds_reader" {
  user = aws_iam_user.seeds_reader.name
}

resource "aws_iam_policy" "seeds_reader" {
  name = "${local.reader_name}-policy"
  path = "/"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject",
            "s3:ListMultipartUploadParts"
          ],
          "Resource" : [
            "arn:aws:s3:::${var.bucket_name}/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
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

resource "aws_iam_user_policy_attachment" "seeds_reader" {
  user       = aws_iam_user.seeds_reader.name
  policy_arn = aws_iam_policy.seeds_reader.arn
}

resource "kubernetes_secret" "seeds_reader" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "${local.reader_name}-secret"
    namespace = each.value
  }

  data = {
    iam_username  = local.reader_name
    username      = aws_iam_access_key.seeds_reader.id
    password      = aws_iam_access_key.seeds_reader.secret
    bucket_name   = var.bucket_name
    bucket_region = aws_s3_bucket.seeds.region
  }
}

resource "aws_iam_user" "seeds_admin" {
  name = local.admin_name
  tags = var.aws_tags
}

resource "aws_iam_access_key" "seeds_admin" {
  user = aws_iam_user.seeds_admin.name
}

resource "aws_iam_policy" "seeds_admin" {
  name = "${local.admin_name}-policy"
  path = "/"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject",
            "s3:DeleteObject",
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

resource "aws_iam_user_policy_attachment" "seeds_admin" {
  user       = aws_iam_user.seeds_admin.name
  policy_arn = aws_iam_policy.seeds_admin.arn
}

resource "kubernetes_secret" "seeds_admin" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "${local.admin_name}-secret"
    namespace = each.value
  }

  data = {
    iam_username  = local.admin_name
    username      = aws_iam_access_key.seeds_admin.id
    password      = aws_iam_access_key.seeds_admin.secret
    bucket_name   = var.bucket_name
    bucket_region = aws_s3_bucket.seeds.region
  }
}


