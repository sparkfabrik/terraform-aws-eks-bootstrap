data "aws_caller_identity" "current" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.13"

  cluster_name                    = var.cluster.name
  cluster_version                 = var.cluster.version
  cluster_endpoint_public_access  = var.cluster.enable_endpoint_public_access
  cluster_endpoint_private_access = var.cluster.enable_endpoint_private_access

  # https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html 
  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }

    coredns = {
      most_recent = true
    }

    aws-ebs-csi-driver = {
      most_recent = true
    }

    vpc-cni = {
      most_recent    = true
      before_compute = true
    }
  }

  cluster_enabled_log_types              = var.cluster.enabled_log_types
  cloudwatch_log_group_retention_in_days = var.cluster.log_group_retention_in_days

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # EKS Managed Node Group(s)
  # eks_managed_node_group_defaults = var.cluster.eks_managed_node_group_defaults

  eks_managed_node_groups = var.cluster.eks_managed_node_groups
}

module "metrics_server" {
  source        = "./modules/metrics-server"
  chart_version = var.cluster.metrics_server.chart_version
}

module "cluster_autoscaler" {
  source                   = "./modules/cluster-autoscaler"
  cluster_name             = var.cluster.name
  cluster_region           = var.aws_default_region
  chart_version            = var.cluster.autoscaler.chart_version
  oidc_provider_arn        = module.eks.oidc_provider_arn
  scale_down_cpu_threshold = var.cluster.autoscaler.scale_down_cpu_threshold

  depends_on = [module.metrics_server]
}

module "node_termination_handler" {
  source            = "./modules/node-termination-handler"
  oidc_provider_arn = module.eks.oidc_provider_arn
  chart_version     = var.cluster.node_termination_handler.chart_version

  depends_on = [module.metrics_server]
}

module "fluentbit" {
  source                            = "./modules/fluentbit"
  cluster_name                      = var.cluster.name
  cluster_region                    = var.aws_default_region
  account_id                        = data.aws_caller_identity.current.account_id
  fluent_bit_image_tag              = var.cluster.fluentbit.fluent_bit_image_tag
  fluent_bit_enable_logs_collection = var.cluster.fluentbit.fluent_bit_enable_logs_collection
  fluent_bit_http_server            = var.cluster.fluentbit.fluent_bit_http_server
  fluent_bit_http_port              = var.cluster.fluentbit.fluent_bit_http_port
  fluent_bit_read_from_head         = var.cluster.fluentbit.fluent_bit_read_from_head
  fluent_bit_read_from_tail         = var.cluster.fluentbit.fluent_bit_read_from_tail
  fluent_bit_log_retention_days     = var.cluster.fluentbit.fluent_bit_log_retention_days
}

module "calico" {
  source        = "./modules/calico"
  chart_version = var.cluster.calico.chart_version
}

# module "fluent_bit" {
#   source            = "./modules/fluent-bit"
#   cluster_name      = var.cluster.name
#   cluster_region    = var.aws_default_region
#   chart_version     = var.cluster.fluent_bit.chart_version
#   namespace         = var.cluster.fluent_bit.namespace
#   oidc_provider_arn = module.eks.oidc_provider_arn
# }

# module "cert_manager" {
#   source = "./modules/certificate-manager"
#   chart_version               = var.cluster.cert_manager.chart_version
#   namespace                   = var.cluster.cert_manager.namespace
#   helm_release_name           = var.cluster.cert_manager.helm_release_name
#   cluster_issuer_name         = var.cluster.cert_manager.cluster_issuer_name
#   secret_name                 = var.cluster.cert_manager.secret_name
#   staging_cluster_issuer_name = var.cluster.cert_manager.staging_cluster_issuer_name
#   staging_secret_name         = var.cluster.cert_manager.staging_secret_name
#   email                       = var.cluster.cert_manager.email
#   install_cluster_issuer      = var.cluster.cert_manager.install_cluster_issuer
# }

# module "alb_controller" {
#   source = "./modules/alb-controller"

#   cluster_name      = var.cluster.name
#   chart_version     = var.cluster.alb_controller.chart_version
#   namespace         = var.cluster.alb_controller.namespace
#   cluster_region    = var.aws_default_region
#   vpc_id            = var.vpc_id
#   oidc_provider_arn = module.eks.oidc_provider_arn

#   # depends_on = [
#   #   module.cert_manager,
#   # ]
# }

# Application namespaces developer access
# module "cluster_access" {
#   source = "./modules/cluster-access"

#   namespaces           = var.cluster.cluster_access.namespaces
#   developer_group_name = var.cluster.cluster_access.developer_group_name
#   admin_group_name     = var.cluster.cluster_access.admin_group_name
# }

# module "ingress_nginx" {
#   source            = "./modules/ingress-nginx"
#   helm_release_name = var.cluster.ingress_nginx.helm_release_name
#   namespace         = var.cluster.ingress_nginx.namespace
#   chart_version     = var.cluster.ingress_nginx.chart_version
#   aws_tags          = var.cluster.ingress_nginx.aws_tags
#   nlb_name          = var.cluster.ingress_nginx.nlb_name
# }

# data "aws_eks_cluster" "cluster" {
#   name = module.eks.cluster_name
# }

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubectl" {
  load_config_file       = false
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
