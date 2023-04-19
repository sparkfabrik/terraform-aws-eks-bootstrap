variable "chart_version" {
  description = "Cluster Autoscaler Chart Version"
  type        = string
}

variable "namespace" {
  description = "Cluster Autoscaler Namespace"
  type        = string
}

variable "iam_role_arn" {
  description = "Cluster Autoscaler IAM Role ARN"
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
  default     = 0.8
}

variable "helm_release_name" {
  description = "Helm Release Name"
  type        = string
}
