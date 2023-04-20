# ################################################################################
# # Cluster
# ################################################################################

# # output "cluster_arn" {
# #   description = "The Amazon Resource Name (ARN) of the cluster"
# #   value       = module.eks.cluster_arn
# # }

# # output "cluster_certificate_authority_data" {
# #   description = "Base64 encoded certificate data required to communicate with the cluster"
# #   value       = module.eks.cluster_certificate_authority_data
# # }

# # output "cluster_endpoint" {
# #   description = "Endpoint for your Kubernetes API server"
# #   value       = module.eks.cluster_endpoint
# # }

# # output "cluster_id" {
# #   description = "The ID of the EKS cluster. Note: currently a value is returned only for local EKS clusters created on Outposts"
# #   value       = module.eks.cluster_id
# # }

# # output "cluster_name" {
# #   description = "The name of the EKS cluster"
# #   value       = module.eks.cluster_name
# # }

# # output "cluster_oidc_issuer_url" {
# #   description = "The URL on the EKS cluster for the OpenID Connect identity provider"
# #   value       = module.eks.cluster_oidc_issuer_url
# # }

# # output "cluster_platform_version" {
# #   description = "Platform version for the cluster"
# #   value       = module.eks.cluster_platform_version
# # }

# # output "cluster_status" {
# #   description = "Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`"
# #   value       = module.eks.cluster_status
# # }

# # output "cluster_primary_security_group_id" {
# #   description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
# #   value       = module.eks.cluster_primary_security_group_id
# # }

# ################################################################################
# # Security Group
# ################################################################################

# output "cluster_security_group_arn" {
#   description = "Amazon Resource Name (ARN) of the cluster security group"
#   value       = module.eks.cluster_security_group_arn
# }

# output "cluster_security_group_id" {
#   description = "ID of the cluster security group"
#   value       = module.eks.cluster_security_group_id
# }

# ################################################################################
# # Node Security Group
# ################################################################################

# # output "node_security_group_arn" {
# #   description = "Amazon Resource Name (ARN) of the node shared security group"
# #   value       = module.eks.node_security_group_arn
# # }

# # output "node_security_group_id" {
# #   description = "ID of the node shared security group"
# #   value       = module.eks.node_security_group_id
# # }

# ################################################################################
# # IAM Role
# ################################################################################

# # output "cluster_iam_role_name" {
# #   description = "IAM role name of the EKS cluster"
# #   value       = module.eks.cluster_iam_role_name
# # }

# # output "cluster_iam_role_arn" {
# #   description = "IAM role ARN of the EKS cluster"
# #   value       = module.eks.cluster_iam_role_arn
# # }

# # output "cluster_iam_role_unique_id" {
# #   description = "Stable and unique string identifying the IAM role"
# #   value       = module.eks.cluster_iam_role_unique_id
# # }

# ################################################################################
# # EKS Addons
# ################################################################################

# output "cluster_addons" {
#   description = "Map of attribute maps for all EKS cluster addons enabled"
#   value       = module.eks.cluster_addons
# }

# ################################################################################
# # CloudWatch Log Group
# ################################################################################

# output "cloudwatch_log_group_name" {
#   description = "Name of cloudwatch log group created"
#   value       = module.eks.cloudwatch_log_group_name
# }

# output "cloudwatch_log_group_arn" {
#   description = "Arn of cloudwatch log group created"
#   value       = module.eks.cloudwatch_log_group_arn
# }

# ################################################################################
# # EKS Managed Node Group
# ################################################################################

# output "eks_managed_node_groups" {
#   description = "Map of attribute maps for all EKS managed node groups created"
#   value       = module.eks.eks_managed_node_groups
# }

# output "eks_managed_node_groups_autoscaling_group_names" {
#   description = "List of the autoscaling group names created by EKS managed node groups"
#   value       = module.eks.eks_managed_node_groups_autoscaling_group_names
# }

# ################################################################################
# # VPC
# ################################################################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

# ################################################################################
# # ECR
# ################################################################################
# output "application_repository_url" {
#   description = "The ARN of the ECR repository"
#   value       = aws_ecr_repository.repositories.repository_url
# }
