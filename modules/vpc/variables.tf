variable "cluster_name" {
  type = string
}

variable "vpc" {
  type = object({
    cidr_block                = string
    azs                       = list(string)
    public_subnet_cidr_block  = list(string)
    private_subnet_cidr_block = list(string)
    service_subnet_cidr_block = list(string)
    enable_nat_gateway        = bool
    enable_single_nat_gateway = bool
  })
}
