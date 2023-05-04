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

variable "bucket_name" {
  type = string
}

variable "enable_bucket_lifecycle" {
  type = bool
}

variable "infrequently_access_days" {
  type = number
}

variable "glacier_days" {
  type = number
}

variable "expiration_days" {
  type = number
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

variable "aws_tags" {
  type        = map(string)
  default     = {}
  description = "Optional additional AWS tags"
}
