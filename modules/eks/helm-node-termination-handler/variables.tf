variable "chart_version" {
  description = "Node termination handler Chart Version"
  type        = string
}

variable "namespace" {
  description = "Node termination handler Namespace"
  type        = string
}

variable "iam_role_arn" {
  description = "Node termination handler IAM Role ARN"
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
