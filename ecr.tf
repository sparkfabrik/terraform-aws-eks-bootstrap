## Creaate ECR repositories
## By convention, the ECR repository name is the customer application key plus the repository name.

locals {
  customer_application_repositories = distinct(flatten([
    for k, app in var.customer_application : [
      for repo in app.repositories : {
        app_name  = k
        repo_name = repo
      }
  ]]))
}

## Create ECR repository
resource "aws_ecr_repository" "repository" {
  for_each = { for entry in local.customer_application_repositories : "${entry.app_name}-${entry.repo_name}" => entry }
  name     = each.key

  tags = {
    Cluster     = var.cluster_name
    Application = each.key
  }
}

resource "aws_ecr_lifecycle_policy" "project_image" {
  for_each = var.repository_expiration_days != null ? { for entry in local.customer_application_repositories : "${entry.app_name}-${entry.repo_name}" => entry } : {}

  repository = each.key

  policy = jsonencode({
    rules = [
      {
        "rulePriority" : 1,
        "description" : "Keep image tagged with main, master, stage, dev*, review*",
        "selection" : {
          "tagStatus" : "tagged",
          "tagPrefixList" : ["main", "master", "stage", "dev*", "review*"],
          "countType" : "imageCountMoreThan",
          "countNumber" : 9999
        },
        "action" : {
          "type" : "expire"
        }
      },
      {
        "rulePriority" : 2,
        "description" : "Remove images older than ${var.repository_expiration_days} days",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "sinceImagePushed",
          "countUnit" : "days",
          "countNumber" : var.repository_expiration_days
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
}
