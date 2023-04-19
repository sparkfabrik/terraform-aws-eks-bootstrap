################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name                   = "${var.eks_cluster_name}-vpc"
  cidr                   = var.vpc.cidr_block
  azs                    = var.vpc.azs
  private_subnets        = var.vpc.private_subnet_cidr_block
  public_subnets         = var.vpc.public_subnet_cidr_block
  enable_nat_gateway     = var.vpc.enable_nat_gateway
  single_nat_gateway     = var.vpc.enable_single_nat_gateway
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true

  tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    Cluster                                     = var.eks_cluster_name
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
    Cluster                                     = var.eks_cluster_name
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
    Cluster                                     = var.eks_cluster_name
  }
}

resource "aws_subnet" "service_subnet" {
  for_each = zipmap(var.vpc.azs, var.vpc.service_subnet_cidr_block)

  vpc_id            = module.vpc.vpc_id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name    = "${var.eks_cluster_name}-vpc-service-${each.key}"
    Cluster = var.eks_cluster_name
  }
}
