## Create ECR repository
resource "aws_ecr_repository" "repository" {
  for_each = var.enable_ecr ? var.customer_application : {}

  name = each.key

  tags = {
    Cluster = var.cluster_name
    Application = each.key
  }
}
