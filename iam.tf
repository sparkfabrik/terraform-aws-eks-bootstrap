
# module "allow_eks_access_iam_policy" {
#   source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
#   version       = "~> 5.17"
#   name          = "allow-eks-access"
#   create_policy = true
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "eks:DescribeCluster",
#           "eks:ListClusters",
#           "eks:ListFargateProfiles",
#           "eks:ListNodegroups",
#           "eks:ListNodegroups",
#           "eks:ListUpdates",
#           "eks:ListTagsForResource",
#           "eks:DescribeFargateProfile",
#           "eks:DescribeNodegroup",
#           "eks:DescribeUpdate",
#           "eks:DescribeCluster",
#           "eks:DescribeAddonVersions",
#           "eks:ListAddons",
#           "eks:DescribeAddon",
#           "eks:ListIdentityProviderConfigs",
#           "eks:DescribeIdentityProviderConfig",
#           "eks:ListTagsForResource",
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       }
#     ]
#   })
# }

# module "eks_admin_iam_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "~> 5.17"

#   role_name         = "eks-admin"
#   create_role       = true
#   role_requires_mfa = false

# }
################################################################################
# IRSA Roles
################################################################################

# module "cert_manager_irsa_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 5.17"

#   role_name                     = "cert-manager"
#   attach_cert_manager_policy    = true
#   cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/IClearlyMadeThisUp"]

#   oidc_providers = {
#     ex = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:cert-manager"]
#     }
#   }

# }

module "cluster_autoscaler_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.17"

  role_name                        = "cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [module.eks.cluster_name]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${var.cluster_autoscaler_namespace}:${var.cluster_autoscaler_helm_release_name}}"]
    }
  }

}

# module "ebs_csi_irsa_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 5.17"

#   role_name             = "ebs-csi"
#   attach_ebs_csi_policy = true

#   oidc_providers = {
#     ex = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
#     }
#   }

# }

module "load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.17"

  role_name                              = "load-balancer-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${var.alb_ingress_controller_namespace}:${var.alb_ingress_controller_helm_release_name}"]
    }
  }
}

module "node_termination_handler_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.17"

  role_name                              = "node-termination-handler"
  attach_node_termination_handler_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${var.node_termination_handler_namespace}:${var.node_termination_handler_helm_release_name}"]
    }
  }
}

# module "velero_irsa_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 5.17"

#   role_name             = "velero"
#   attach_velero_policy  = true
#   velero_s3_bucket_arns = ["arn:aws:s3:::velero-backups"]

#   oidc_providers = {
#     ex = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["velero:velero"]
#     }
#   }

# }
