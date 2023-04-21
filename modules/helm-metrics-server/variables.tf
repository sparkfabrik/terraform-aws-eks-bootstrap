variable "namespace" {
  type        = string
  description = "Namespace to install metrics-server"
}

variable "chart_version" {
  type        = string
  description = "Version of the metrics-server chart to install"
}

variable "helm_release_name" {
  type        = string
  description = "Name of the helm release"
}
