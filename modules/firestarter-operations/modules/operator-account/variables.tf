variable "namespaces" {
  type = list(string)
}

variable "oidc_provider_url" {
  type = string
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_tags" {
  type        = map(string)
  default     = {}
  description = "Optional additional AWS tags"
}

variable "iam_role_name_prefix" {
  type = string
}

variable "iam_policy_name_prefix" {
  type = string
}

variable "service_account_name_prefix" {
  type = string
}

variable "seeds_bucket_name" {
  type = string
}
