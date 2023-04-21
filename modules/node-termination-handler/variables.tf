variable "chart_version" {
  description = "Node termination handler Chart Version"
  type        = string
}

variable "namespace" {
  description = "Node termination handler Namespace"
  type        = string
}

variable "helm_release_name" {
  description = "Helm Release Name"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN"
  type        = string
}
