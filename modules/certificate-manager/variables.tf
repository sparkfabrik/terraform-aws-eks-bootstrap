variable "helm_release_name" {
  type        = string
  description = "Name of the helm release"
}

variable "cluster_issuer_name" {
  type        = string
  description = "Name of the cluster issuer to use"
}

variable "secret_name" {
  type        = string
  description = "Name of the secret to use"
}

variable "staging_cluster_issuer_name" {
  type        = string
  description = "Name of the staging cluster issuer to use"
}

variable "staging_secret_name" {
  type        = string
  description = "Name of the staging secret to use"
}

variable "email" {
  type        = string
  description = "Email to use for the cluster issuer"
}

variable "namespace" {
  type        = string
  description = "Namespace to install cert-manager"
}

variable "chart_version" {
  type        = string
  description = "Version of the cert-manager chart to install"
}

variable "install_cluster_issuer" {
  type        = bool
  description = "Whether to install a cluster issuer or not"
}
