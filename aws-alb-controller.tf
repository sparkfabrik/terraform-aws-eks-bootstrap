# locals {
#   serviceaccount_name = "aws-load-balancer-controller"
#   alb_controller = {
#     namespace = "kube-system"
#     chart_version = "1.5.2"
#     helm_release_name = "aws-load-balancer-controller"
#   }
# }

# module "load_balancer_controller_irsa_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 5.17"

#   role_name                              = "load-balancer-controller"
#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     ex = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["${local.alb_controller.namespace}:${local.alb_controller.helm_release_name}"]
#     }
#   }
# }

# resource "helm_release" "aws_load_balancer_controller_release" {
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = local.cluster_autoscaler.namespace
#   version    = local.alb_controller.chart_version
#   values = [templatefile(
#     "${path.module}/files/aws-alb-controller/values.yaml",
#     {
#       serviceaccount_name = local.serviceaccount_name
#       cluster_name        = var.cluster_name
#       cluster_region      = data.aws_region.current.name
#       vpc_id              = var.vpc_id
#       account_id          = data.aws_caller_identity.current.account_id
#       iam_role_arn        = module.load_balancer_controller_irsa_role.iam_role_arn
#     }
#     )
#   ]
# }