output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "ingress_nginx_dns_name" {
  value = var.enable_ingress_nginx ? data.aws_lb.ingress_nginx[0].dns_name : ""
}

output "customer_application_ecr_repository" {
  value = var.enable_ecr ? { for repo in aws_ecr_repository.repository : repo.name => repo.repository_url } : {}
}
