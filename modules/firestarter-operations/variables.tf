variable "namespaces" {
  type = list(string)
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

variable "oidc_provider_url" {
  type = string
}

variable "enable_seeds" {
  description = "This module will create one bucket to host the database seeds and two IAM user with two access level (reader and writer)"
  type        = bool
  default     = false
}

variable "enable_operator_account" {
  description = "This module will create the kubernetes service account used to access (in read mode) the seed bucket and to manage (read/write) the all Drupal buckets"
  type        = bool
  default     = false
}

variable "operator_account_role_name_prefix" {
  type    = string
  default = "operator-account"
}

variable "operator_account_policy_name_prefix" {
  type    = string
  default = "operator-account"
}

variable "operator_account_service_account_name_prefix" {
  type    = string
  default = "operator-account"
}

variable "enable_uninstalled_releases" {
  description = "This module will create one bucket to store all the uninstalled releases data (assets and database dump) and the related kubernetes service account"
  type        = bool
  default     = false
}

# Refs to the minimum storage duration: https://aws.amazon.com/s3/pricing/?nc=sn&loc=4
variable "uninstalled_releases_enable_bucket_lifecycle" {
  type    = bool
  default = true
}

variable "uninstalled_releases_infrequently_access_days" {
  type    = number
  default = 30
}

variable "uninstalled_releases_glacier_days" {
  type    = number
  default = 60
}

variable "uninstalled_releases_expiration_days" {
  type    = number
  default = 150
}

variable "uninstalled_releases_role_name_prefix" {
  type    = string
  default = "uninstalled-releases"
}

variable "uninstalled_releases_policy_name_prefix" {
  type    = string
  default = "uninstalled-releases"
}

variable "uninstalled_releases_service_account_name_prefix" {
  type    = string
  default = "uninstalled-releases"
}

variable "enable_dumps" {
  description = "This module will create one bucket to store database dumps for cronjob operations"
  type        = bool
  default     = false
}

# Refs to the minimum storage duration: https://aws.amazon.com/s3/pricing/?nc=sn&loc=4
variable "dumps_enable_bucket_lifecycle" {
  type    = bool
  default = true
}

variable "dumps_infrequently_access_days" {
  type    = number
  default = 30
}

variable "dumps_glacier_days" {
  type    = number
  default = 60
}

variable "dumps_expiration_days" {
  type    = number
  default = 150
}

variable "dumps_admin_role_name_prefix" {
  type    = string
  default = "dumps-admin"
}

variable "dumps_admin_policy_name_prefix" {
  type    = string
  default = "dumps-admin"
}

variable "dumps_admin_service_account_name_prefix" {
  type    = string
  default = "dumps-admin"
}
