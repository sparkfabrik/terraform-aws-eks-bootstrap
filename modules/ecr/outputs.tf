output "application_repositories" {
  value = [
    for repository in aws_ecr_repository.repositories :
    repository.repository_url
  ]
}
