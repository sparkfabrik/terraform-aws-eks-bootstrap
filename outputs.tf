output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "ingress_nginx_dns_name" {
  value = var.enable_ingress_nginx ? data.aws_lb.ingress_nginx[0].dns_name : ""
}

output "ingress_nginx_zone_id" {
  value = var.enable_ingress_nginx ? data.aws_lb.ingress_nginx[0].zone_id : ""
}

output "customer_application_namespaces" {
  value = local.eks_application_namespaces
}

output "customer_application_ecr_repository" {
  value = { for repo in aws_ecr_repository.repository : repo.name => repo.repository_url }
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

## Grafana password
output "grafana_admin_password" {
  sensitive = true
  value     = var.enable_kube_prometheus_stack ? module.kube_prometheus_stack[0].grafana_admin_password : "N/D"
}

output "managed_node_group_iam_roles" {
  value = {
    for key, node_group in module.eks.eks_managed_node_groups :
      key => node_group.iam_role_name
  }
  description = "IAM role names of the EKS managed node groups"
}