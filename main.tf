
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.13"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  cluster_addons = {
    vpc-cni = {
      most_recent = true
    }
  }

  # Enable OIDC Provider
  enable_irsa = true

  eks_managed_node_group_defaults = local.eks_managed_node_group_defaults
  eks_managed_node_groups         = var.eks_managed_node_groups

  cluster_enabled_log_types              = var.cluster_enabled_log_types
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days

  manage_aws_auth_configmap = true
  # map developer & admin ARNs as kubernetes Users
  aws_auth_users = concat(local.admin_user_map_users, local.developer_user_map_users, var.cluster_map_users)

  tags = {
    Cluster = var.cluster_name
    Project = var.project
  }
}

module "gitlab_runner" {
  count = var.enable_gitlab_runner ? 1 : 0

  source = "github.com/sparkfabrik/terraform-aws-eks-gitlab-runner?ref=071e1cf"

  # The registration token is from https://gitlab.sparkfabrik.com/groups/toitaly-group/-/runners
  runner_registration_token   = var.gitlab_runner_registration_token
  runner_tags                 = join(",", var.gitlab_runner_tags)
  eks_cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  add_external_runner_user    = var.add_gitlab_runner_external_user
}

# module "cluster_access" {
#   source     = "./cluster-access"
#   namespaces = keys(var.cluster_application)
#   depends_on = [module.eks, kubernetes_namespace.application_namespace]
# }
