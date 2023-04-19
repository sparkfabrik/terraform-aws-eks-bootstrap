terraform {
  required_version = ">= 1.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.19"
    }
  }
}


# data "aws_eks_cluster_auth" "cluster" {
#   name = module.cluster_definition.cluster_id
# }

# # -----------------
# # PROVIDERS CONFIG
# # -----------------
# provider "aws" {
#   region = var.aws_default_region
#   #   default_tags {
#   #     tags = var.default_tags
#   #   }
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
# }

# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.cluster.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#     token                  = data.aws_eks_cluster_auth.cluster.token
#   }
# }
