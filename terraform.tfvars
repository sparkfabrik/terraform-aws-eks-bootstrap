vpc = {
  cidr_block                = "10.0.0.0/16"
  azs                       = ["eu-west-1a", "eu-west-1b"]
  public_subnet_cidr_block  = ["10.0.20.0/23", "10.0.24.0/23"]
  private_subnet_cidr_block = ["10.0.0.0/23", "10.0.4.0/23"]
  service_subnet_cidr_block = ["10.0.10.0/23", "10.0.14.0/23"]
}

eks_cluster_name = "to-italy-group"
