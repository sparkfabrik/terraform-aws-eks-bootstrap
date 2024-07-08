# To install some add-ons we must create the IAM assumable role before the add-on installation.
# https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html
# See "Amazon EBS CSI driver" or "Amazon CloudWatch Observability agent" sections for more details.
locals {
  eks_addons_sa_and_roles = var.enable_default_eks_addons ? merge(
    {
      "aws-node" = {
        namespace = "kube-system",
        role_name = "AmazonEKSVPCCNIRole",
        # If you need to manage IPv6 addresses, you must create and use the policy for the IPv6 address range.
        # You can find more information in: https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html
        # in the "Amazon VPC CNI plugin for Kubernetes" section.
        policies = [
          "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        ],
      },
    },  
    var.cluster_enable_amazon_cloudwatch_observability_addon ? {
      "cloudwatch-agent" = {
        namespace = "amazon-cloudwatch",
        role_name = "AmazonEKS_Observability_Role",
        policies = [
          "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess",
          "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
        ],
      }
    } : {}
  ) : {}
}

module "iam_assumable_role_with_oidc_for_eks_addons" {
  for_each = local.eks_addons_sa_and_roles

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.0"

  create_role = true
  role_name   = each.value.role_name

  provider_url = module.eks.cluster_oidc_issuer_url

  role_policy_arns = each.value.policies

  oidc_fully_qualified_subjects = [
    "system:serviceaccount:${each.value.namespace}:${each.key}",
  ]
}

# Addons
# https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html#workloads-add-ons-available-eks
# ATTENTION: to disable the NetworkPolicies feature, you need to delete ALL NetworkPolicy resources in the cluster before disabling the addon.
# https://github.com/aws/aws-network-policy-agent/issues/135
locals {
  eks_addons = var.enable_default_eks_addons ? merge(
    {
      vpc-cni = {
        most_recent              = true,
        preserve                 = true,
        service_account_role_arn = module.iam_assumable_role_with_oidc_for_eks_addons["aws-node"].iam_role_arn,
      },
    },
    var.cluster_enable_amazon_cloudwatch_observability_addon ? {
      amazon-cloudwatch-observability = {
        most_recent              = true,
        service_account_role_arn = module.iam_assumable_role_with_oidc_for_eks_addons["cloudwatch-agent"].iam_role_arn,
        configuration_values = jsonencode(
          { "agent" : { "config" : { "logs" : { "metrics_collected" : { "kubernetes" : { "enhanced_container_insights" : var.enhanced_container_insights_enabled } } } } } }
        )
      }
    } : {}
  ) : {}
}
