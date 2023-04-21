variable "chart_version" {
  description = "Cluster Autoscaler Chart Version"
  type        = string
}

variable "namespace" {
  description = "Cluster Autoscaler Namespace"
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

variable "cpu_threshold" {
  description = "CPU Threshold"
  type        = number
}

variable "helm_release_name" {
  description = "Helm Release Name"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN"
  type        = string
}
