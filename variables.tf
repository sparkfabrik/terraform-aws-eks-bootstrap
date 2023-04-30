variable "project" {
  type        = string
  description = "Project name"
}

## VPC
variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

## Cluster definition
variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "The Kubernetes version to use for the EKS cluster. Defaults to the latest supported version"
  default     = "1.24"
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default is true"
  default     = true
}

variable "cluster_endpoint_private_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default is true"
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled."
  default     = ["0.0.0.0/0"]
}

variable "cluster_enabled_log_types" {
  type        = list(string)
  description = "A list of the desired control plane logging to enable. For more information, see Amazon EKS Cluster Logging in the Amazon EKS User Guide."
  default     = []
}

variable "cloudwatch_log_group_retention_in_days" {
  type        = number
  description = "Number of days to retain log events. Default retention - 7 days"
  default     = 7
}

## Cluster access
variable "cluster_map_users" {
  type = list(
    object({
      userarn  = string,
      username = string,
      groups   = list(string)
    })
  )
  default = []
}

variable "admin_users" {
  type = list(any)
}

variable "developer_users" {
  type = list(any)
}

## Cluster Applications
variable "cluster_application" {
  type = map(object({
    namespace = string
  }))
}
