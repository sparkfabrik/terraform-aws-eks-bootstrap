module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  cluster_addons = merge(
    local.eks_addons,
    var.cluster_additional_addons
  )

  iam_role_additional_policies = var.cluster_iam_role_additional_policies

  # Enable OIDC Provider
  enable_irsa = true

  eks_managed_node_group_defaults = local.eks_managed_node_group_defaults
  eks_managed_node_groups         = var.eks_managed_node_groups

  cluster_enabled_log_types              = var.cluster_enabled_log_types
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days

  authentication_mode = "CONFIG_MAP"
  
  tags = {
    Cluster = var.cluster_name
    Project = var.project
  }
}

module "eks_aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = true

  aws_auth_users = concat(local.admin_user_map_users, local.developer_user_map_users, var.cluster_access_map_users)
}

module "gitlab_runner" {
  count = var.enable_gitlab_runner ? 1 : 0

  source = "github.com/sparkfabrik/terraform-aws-eks-gitlab-runner?ref=4e020f8"

  runner_registration_token     = var.gitlab_runner_registration_token
  runner_tags                   = join(",", var.gitlab_runner_tags)
  eks_cluster_oidc_issuer_url   = module.eks.cluster_oidc_issuer_url
  runner_additional_policy_arns = var.gitlab_runner_additional_policy_arns
}

module "firestarter_operations" {
  count = var.enable_firestarter_operations ? 1 : 0

  source                      = "./modules/firestarter-operations"
  namespaces                  = ["townsofitaly-stage"]
  oidc_provider_url           = module.eks.cluster_oidc_issuer_url
  project                     = var.cluster_name
  environment                 = "stage"
  enable_seeds                = true
  enable_operator_account     = true
  enable_uninstalled_releases = true
  enable_dumps                = true
}

# Application namespaces developer access
module "cluster_access" {
  source = "github.com/sparkfabrik/terraform-kubernetes-cluster-access?ref=0.3.0"

  namespaces       = local.eks_application_namespaces
  developer_groups = var.cluster_access_developer_groups
  admin_groups     = var.cluster_access_admin_groups
  k8s_labels = {
    "managed-by" = "terraform"
    "scope"      = "cluster-access"
  }

  depends_on = [module.eks, kubernetes_namespace.customer_application]
}
