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
