variable "aws_default_region" {
  description = "AWS Default Region"
  type        = string
}

# variable "application_projects" {
#   description = "Cluster application projects"
#   type        = object({
#     application = string
#     ecr = list(string)
#     namespace = list(string)
#   })
# }

################################################################################
# VPC Variables
################################################################################
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

################################################################################
# EKS Variables
################################################################################

variable "eks_cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "eks_cluster_version" {
  description = "EKS Cluster Version"
  type        = string
  default     = "1.24"
}

variable "cluster_enabled_log_types" {
  description = "EKS Cluster Enabled Log Types"
  type        = list(string)
  # Possible values: "api", "audit", "authenticator", "controllerManager", "scheduler"
  default = []
}

################################################################################
# Helm Chart Variables
################################################################################

# Cluster Autoscaler
# https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler
variable "cluster_autoscaler_chart_version" {
  description = "Cluster Autoscaler Chart Version"
  type        = string
  default     = "9.28.0"
}

variable "cluster_autoscaler_namespace" {
  description = "Cluster Autoscaler Namespace"
  type        = string
  default     = "kube-system"
}

variable "cluster_autoscaler_helm_release_name" {
  description = "Cluster Autoscaler Helm Release Name"
  type        = string
  default     = "cluster-autoscaler"
}

# ALB Ingress Controller
# https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller

variable "alb_ingress_controller_chart_version" {
  description = "ALB Ingress Controller Chart Version"
  type        = string
  default     = "1.5.1"
}

variable "alb_ingress_controller_namespace" {
  description = "ALB Ingress Controller Namespace"
  type        = string
  default     = "kube-system"
}

variable "alb_ingress_controller_helm_release_name" {
  description = "ALB Ingress Controller Helm Release Name"
  type        = string
  default     = "aws-load-balancer-controller"
}

# Node Termination Handler
# https://artifacthub.io/packages/helm/aws/aws-node-termination-handler

variable "node_termination_handler_chart_version" {
  description = "Node Termination Handler Chart Version"
  type        = string
  default     = "0.21.0"
}

variable "node_termination_handler_namespace" {
  description = "Node Termination Handler Namespace"
  type        = string
  default     = "kube-system"
}

variable "node_termination_handler_helm_release_name" {
  description = "Node Termination Handler Helm Release Name"
  type        = string
  default     = "aws-node-termination-handler"
}
