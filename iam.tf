locals {
  # The namespace list is used from the cluster access module and in the secrets.tf file
  # to create the secret with the AWS credentials and the list of available namespaces.
  namespaces_list = concat(
    [for k, v in var.cluster.cluster_access.namespaces : k],
    # [for k, v in var.self_provisioning_namespaces : k],
  )

  cluster_map_users = var.cluster.cluster_access.enable ? [
    {
      userarn : aws_iam_user.cluster_access_developer[0].arn,
      username : aws_iam_user.cluster_access_developer[0].name,
      groups : [var.cluster.cluster_access.developer_group_name]
    },
    {
      userarn : aws_iam_user.cluster_access_admin[0].arn,
      username : aws_iam_user.cluster_access_admin[0].name,
      groups : [var.cluster.cluster_access.admin_group_name]
    }
  ] : []
}

data "aws_caller_identity" "current" {}

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
      namespace_service_accounts = ["${var.cluster.autoscaler.namespace}:${var.cluster.autoscaler.helm_release_name}"]
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
      namespace_service_accounts = ["${var.cluster.alb_controller.namespace}:${var.cluster.alb_controller.helm_release_name}"]
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
      namespace_service_accounts = ["${var.cluster.node_termination_handler.namespace}:${var.cluster.node_termination_handler.helm_release_name}"]
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

# IAM User
# Create the cluster access for developers
resource "aws_iam_user" "cluster_access_developer" {
  count = var.cluster.cluster_access.enable ? 1 : 0
  name  = "${var.project}-${var.cluster.cluster_access.environment}-eks-access-developer"
}

resource "aws_iam_access_key" "cluster_access_developer" {
  count = var.cluster.cluster_access.enable ? 1 : 0
  user  = aws_iam_user.cluster_access_developer[0].name
}

resource "aws_iam_user" "cluster_access_admin" {
  count = var.cluster.cluster_access.enable ? 1 : 0
  name  = "${var.project}-${var.cluster.cluster_access.environment}-eks-access-admin"
}

resource "aws_iam_access_key" "cluster_access_admin" {
  count = var.cluster.cluster_access.enable ? 1 : 0
  user  = aws_iam_user.cluster_access_admin[0].name
}

resource "aws_iam_policy" "cluster_access" {
  count       = var.cluster.cluster_access.enable ? 1 : 0
  name_prefix = "cluster-access"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "eks:ListClusters"
          "Resource" : "arn:aws:eks:*:${data.aws_caller_identity.current.account_id}:cluster/*"
        },
        {
          "Effect" : "Allow",
          "Action" : "eks:DescribeCluster"
          "Resource" : module.eks.cluster_arn
        }
      ]
    }
  )
}

resource "aws_iam_user_policy_attachment" "cluster_access_developer" {
  user       = aws_iam_user.cluster_access_developer[0].name
  policy_arn = aws_iam_policy.cluster_access[0].arn
}

resource "aws_iam_user_policy_attachment" "cluster_access_admin" {
  user       = aws_iam_user.cluster_access_admin[0].name
  policy_arn = aws_iam_policy.cluster_access[0].arn
}
