## Creaate ECR repositories
## By convention, the ECR repository name is the customer application key plus the repository name.

locals {
  customer_application_repositories = distinct(flatten([
    for k, app in var.customer_application : [
      for repo in app.repositories : {
        app_name = k
        repo_name = repo
      }
  ]]))
}

## Create ECR repository
resource "aws_ecr_repository" "repository" {
  for_each = { for entry in local.customer_application_repositories : "${entry.app_name}-${entry.repo_name}" => entry }
  
  name = each.key

  tags = {
    Cluster = var.cluster_name
    Application = each.key
  }
}

locals {
  ecr_admin_policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

## Crate an IAM user with access to each ECR repository resource
resource "aws_iam_user" "ecr_admin_iam_user" {
  count = var.add_ecr_admin_iam_user ? 1 : 0
  name  = var.add_ecr_admin_iam_user_name

  tags = {
    Cluster = var.cluster_name
  }  
}

resource "aws_iam_access_key" "ecr_admin_iam_user" {
  count = var.add_ecr_admin_iam_user ? 1 : 0
  user  = aws_iam_user.ecr_admin_iam_user[0].name
}

resource "aws_iam_user_policy_attachment" "ecr_admin_iam_user" {
  count      = var.add_ecr_admin_iam_user ? 1 : 0
  user       = aws_iam_user.ecr_admin_iam_user[0].name
  policy_arn = local.ecr_admin_policy_arn
}