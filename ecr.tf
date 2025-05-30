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

  # Generate individual rules for each tag pattern.
  # Please note that tagPatternList is an AND condition in AWS ECR lifecycle policy
  tag_protection_rules = [
    for index, pattern in var.ecr_protected_tag_patterns : {
      rulePriority = index + 1
      description  = "Keep images tagged with ${pattern}"
      selection = {
        tagStatus      = "tagged"
        tagPatternList = [pattern]
        countType      = "imageCountMoreThan"
        countNumber    = 9999
      }
      action = {
        type = "expire"
      }
    }
  ]

  # Rule to clean up old images
  cleanup_rule = {
    rulePriority = length(var.ecr_protected_tag_patterns) + 1
    description  = "Remove images older than ${var.ecr_lifecycle_expiration_days} days"
    selection = {
      tagStatus   = "any"
      countType   = "sinceImagePushed"
      countUnit   = "days"
      countNumber = var.ecr_lifecycle_expiration_days
    }
    action = {
      type = "expire"
    }
  }
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
  for_each = var.ecr_enable_lifecycle_policy ? {
    for repo_name, repo_config in aws_ecr_repository.repository : repo_name => repo_config
    if !contains(var.ecr_lifecycle_policy_excluded_repositories, repo_name)
  } : {}

  repository = each.value.name

  policy = jsonencode({
    rules = concat(local.tag_protection_rules, [local.cleanup_rule])
  })
}
