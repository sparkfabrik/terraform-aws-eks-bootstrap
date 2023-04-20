module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.13"

  cluster_name                    = var.cluster.name
  cluster_version                 = var.cluster.version
  cluster_endpoint_public_access  = var.cluster.enable_endpoint_public_access
  cluster_endpoint_private_access = var.cluster.enable_endpoint_private_access

  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  cluster_enabled_log_types              = var.cluster.enabled_log_types
  cloudwatch_log_group_retention_in_days = var.cluster.cloudwatch_log_group_retention_in_days

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = var.cluster.eks_managed_node_group_defaults

  eks_managed_node_groups = var.cluster.eks_managed_node_groups
}

# Application namespaces developer access
# module "cluster_access" {
#   source               = "./modules/cluster-access"
#   namespaces           = var.cluster.cluster_access.namespaces
#   developer_group_name = var.cluster.cluster_access.developer_group_name
#   admin_group_name     = var.cluster.cluster_access.admin_group_name
# }
