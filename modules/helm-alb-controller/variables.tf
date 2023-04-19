variable "chart_version" {
  description = "ALB Controller Chart Version"
  type        = string
}

variable "namespace" {
  description = "ALB Controller Namespace"
  type        = string
}

variable "iam_role_arn" {
  description = "ALB Controller IAM Role ARN"
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

variable "account_id" {
  type        = string
  description = "The AWS account that will be associated with the service account. Use `aws_caller_identity` in order to avoid to hardcode the AWS account ID."
}
