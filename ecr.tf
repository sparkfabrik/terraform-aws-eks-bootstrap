
resource "aws_ecr_repository" "repositories" {
  name = var.application_projects.name

  tags = {
    Project = var.application_projects.name
  }
}

resource "aws_ecr_lifecycle_policy" "repositories" {
  repository = aws_ecr_repository.repositories.name
 
  policy = jsonencode({
   rules = [{
     rulePriority = 1
     description  = "keep last ${var.application_projects.repository_max_image} images"
     action       = {
       type = "expire"
     }
     selection     = {
       tagStatus   = "any"
       countType   = "imageCountMoreThan"
       countNumber = var.application_projects.repository_max_image
     }
   }]
  })
}