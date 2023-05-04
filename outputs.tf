output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "ingress_nginx_dns_name" {
  value = var.enable_ingress_nginx ? data.aws_lb.ingress_nginx[0].dns_name : ""
}

output "ingress_nginx_zone_id" {
  value = var.enable_ingress_nginx ? data.aws_lb.ingress_nginx[0].zone_id : ""
}

output "customer_application_ecr_repository" {
  value = var.enable_ecr ? { for repo in aws_ecr_repository.repository : repo.name => repo.repository_url } : {}
}

## ECR Admin user
output "ecr_admin_iam_user_name" {
  value = var.add_ecr_admin_iam_user ? aws_iam_user.ecr_admin_iam_user[0].name : ""
}

output "ecr_admin_iam_user_key_id" {
  sensitive = true
  value     = var.add_ecr_admin_iam_user ? aws_iam_access_key.ecr_admin_iam_user[0].id : ""
}

output "ecr_admin_iam_user_key_secret" {
  sensitive = true
  value     = var.add_ecr_admin_iam_user ? aws_iam_access_key.ecr_admin_iam_user[0].secret : ""
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}
