output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "ingress_nginx_dns_name" {
  value = var.enable_ingress_nginx ? data.aws_lb.ingress_nginx[0].dns_name : ""
}

output "ingress_nginx_zone_id" {
  value = var.enable_ingress_nginx ? data.aws_lb.ingress_nginx[0].zone_id : ""
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "aws_eks_cluster_auth_token" {
  value = data.aws_eks_cluster_auth.this.token
}

## ECR
output "customer_application_ecr_repository" {
  value = { for repo in aws_ecr_repository.repository : repo.name => repo.repository_url }
}
