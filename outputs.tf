output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "aws_lb_ingress_dns_name" {
  value = data.aws_lb.ingress_nlb.dns_name
}
