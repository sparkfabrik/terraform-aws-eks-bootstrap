output "lb_dns_name" {
  value       = data.aws_lb.lb_ingress_nginx.dns_name
  description = "DNS name of the NLB"
}

output "lb_zone_id" {
  value       = data.aws_lb.lb_ingress_nginx.zone_id
  description = "Zone ID of the NLB"
}
