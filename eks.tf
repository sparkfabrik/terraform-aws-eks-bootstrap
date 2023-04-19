################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.13"


  cluster_name                    = var.eks_cluster_name
  cluster_version                 = var.eks_cluster_version
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  cluster_enabled_log_types              = var.cluster_enabled_log_types
  cloudwatch_log_group_retention_in_days = 14

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
    disk_size      = 50
  }

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      labels = {
        role = "default"
      }
    }
  }
}

# module "helm_cluster_autoscaler" {
#   source            = "./modules/helm-cluster-autoscaler"
#   chart_version     = var.cluster_autoscaler_chart_version
#   cluster_name      = module.eks.cluster_name
#   iam_role_arn      = module.cluster_autoscaler_irsa_role.iam_role_arn
#   cluster_region    = var.aws_default_region
#   namespace         = var.cluster_autoscaler_namespace
#   helm_release_name = var.cluster_autoscaler_helm_release_name
# }

# module "helm_alb_controller" {
#   source            = "./modules/helm-alb-controller"
#   chart_version     = var.alb_ingress_controller_chart_version
#   cluster_name      = module.eks.cluster_name
#   iam_role_arn      = module.load_balancer_controller_irsa_role.iam_role_arn
#   cluster_region    = var.aws_default_region
#   namespace         = var.alb_ingress_controller_namespace
#   helm_release_name = var.alb_ingress_controller_helm_release_name
#   vpc_id            = module.vpc.vpc_id
#   account_id        = data.aws_caller_identity.current.account_id
# }

# module "helm_node_termination_handler" {
#   source            = "./modules/helm-node-termination-handler"
#   chart_version     = var.node_termination_handler_chart_version
#   cluster_name      = module.eks.cluster_name
#   iam_role_arn      = module.node_termination_handler_irsa_role.iam_role_arn
#   cluster_region    = var.aws_default_region
#   namespace         = var.node_termination_handler_namespace
#   helm_release_name = var.node_termination_handler_helm_release_name
# }
