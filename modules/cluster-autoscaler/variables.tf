variable "chart_version" {
  description = "Cluster Autoscaler Chart Version"
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

variable "scale_down_cpu_threshold" {
  description = "CPU Threshold"
  type        = number
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN"
  type        = string
}
