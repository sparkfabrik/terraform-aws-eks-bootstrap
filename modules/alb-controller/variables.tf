variable "chart_version" {
  description = "ALB Controller Chart Version"
  type        = string
}

variable "namespace" {
  description = "ALB Controller Namespace"
  type        = string
}

variable "cluster_name" {
  description = "Cluster Name"
  type        = string
}

variable "cluster_region" {
  description = "Cluster Region"
  type        = string
}

variable "helm_release_name" {
  description = "Helm Release Name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN"
  type        = string
}
