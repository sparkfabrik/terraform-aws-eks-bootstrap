# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "~> 4.0"

#   name                   = "${var.cluster.name}-vpc"
#   cidr                   = var.vpc.cidr_block
#   azs                    = var.vpc.azs
#   private_subnets        = var.vpc.private_subnet_cidr_block
#   public_subnets         = var.vpc.public_subnet_cidr_block
#   enable_nat_gateway     = var.vpc.enable_nat_gateway
#   single_nat_gateway     = var.vpc.enable_single_nat_gateway
#   one_nat_gateway_per_az = false
#   enable_dns_hostnames   = true

#   tags = {
#     "kubernetes.io/cluster/${var.cluster.name}" = "shared"
#     Cluster                                     = var.cluster.name
#   }

#   public_subnet_tags = {
#     "kubernetes.io/cluster/${var.cluster.name}" = "shared"
#     "kubernetes.io/role/elb"                    = "1"
#     Cluster                                     = var.cluster.name
#   }

#   private_subnet_tags = {
#     "kubernetes.io/cluster/${var.cluster.name}" = "shared"
#     "kubernetes.io/role/internal-elb"           = "1"
#     Cluster                                     = var.cluster.name
#   }
# }

# resource "aws_subnet" "service_subnet" {
#   for_each = zipmap(var.vpc.azs, var.vpc.service_subnet_cidr_block)

#   vpc_id            = module.vpc.vpc_id
#   cidr_block        = each.value
#   availability_zone = each.key

#   tags = {
#     Name    = "${var.cluster.name}-vpc-service-${each.key}"
#     Cluster = var.cluster.name
#   }
# }

## VPC
module "vpc" {
  source = "./modules/vpc"
  cluster_name = var.cluster.name
  vpc = var.vpc
}

## ECR
module "ecr_repository" {
  source = "./modules/ecr"
  cluster_name = var.cluster.name
  application_project = var.application_project
}

## RDS
module "rds" {
  source = "./modules/rds"
  cluster_name = var.cluster.name
  vpc_id = module.vpc.vpc_id
  vpc_cidr_block = var.vpc.cidr_block
  subnet_ids = module.vpc.service_subnet_ids
  application_project = var.application_project
}

## Cache
module "cache" {
  source = "./modules/cache"
  cluster_name = var.cluster.name
  vpc_id = module.vpc.vpc_id
  vpc_cidr_block = var.vpc.cidr_block
  subnet_ids = module.vpc.service_subnet_ids
  application_project = var.application_project  
}

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 19.13"


#   cluster_name                    = var.cluster.name
#   cluster_version                 = var.cluster.version
#   cluster_endpoint_public_access  = true
#   cluster_endpoint_private_access = true

#   cluster_addons = {
#     kube-proxy = {
#       most_recent = true
#     }
#     aws-ebs-csi-driver = {
#       most_recent = true
#     }
#   }

#   cluster_enabled_log_types              = var.cluster.enabled_log_types
#   cloudwatch_log_group_retention_in_days = 14

#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnets

#   # EKS Managed Node Group(s)
#   eks_managed_node_group_defaults = {
#     instance_types = ["t3.medium"]
#     disk_size      = 50
#   }

#   eks_managed_node_groups = {
#     default = {
#       min_size     = 1
#       max_size     = 2
#       desired_size = 1

#       instance_types = ["t3.small"]
#       capacity_type  = "SPOT"
#       labels = {
#         role = "default"
#       }
#     }
#   }
# }