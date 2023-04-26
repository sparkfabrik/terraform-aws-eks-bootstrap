variable "namespace" {
  type        = string
  description = "Namespace to install Fluent Bit"
}

variable "chart_version" {
  type        = string
  description = "Version of the Fluent Bit chart to install"
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "cluster_region" {
  description = "Cluster Region"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN"
  type        = string
}
