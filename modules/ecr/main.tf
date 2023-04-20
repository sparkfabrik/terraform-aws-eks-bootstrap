resource "aws_ecr_repository" "repositories" {
  for_each = var.application_project

  name = "${var.cluster_name}-${each.key}"

  tags = {
    Cluster     = var.cluster_name
    Application = each.key
  }
}

resource "aws_ecr_lifecycle_policy" "repositories" {
  for_each = var.application_project

  repository = aws_ecr_repository.repositories[each.key].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last ${each.value.repository_max_image} images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = each.value.repository_max_image
      }
    }]
  })

  depends_on = [
    aws_ecr_repository.repositories
  ]
}
