variable "aws_tags" {
  type        = map(string)
  description = "AWS tags are requireds here because we don't create directly AWS resources, but via LB controller"
}

variable "namespace" {
  type        = string
  description = "Namespace for ingress-nginx"
}

variable "chart_version" {
  type        = string
  description = "Chart version for ingress-nginx"
}

variable "nlb_name" {
  type        = string
  description = "Name of the NLB created by the LB controller"
}

variable "helm_release_name" {
  type        = string
  description = "Name of the helm release for ingress-nginx"
}
