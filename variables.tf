## General
variable "project" {
  type        = string
  description = "Project name"
}

## VPC
variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
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
  description = "The Kubernetes version to use for the EKS cluster."
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
  description = "Number of days to retain log events."
  default     = 7
}

## Cluster node group
variable "eks_managed_node_groups" {
  type = any
  default = {
    core_pool = {
      min_size       = 1
      max_size       = 4
      desired_size   = 2
      instance_types = ["t3.medium"]
      labels = {
        Pool = "core"
      }
      # taints = {
      #   dedicated = {
      #     key    = "dedicated"
      #     value  = "gpuGroup"
      #     effect = "NO_SCHEDULE"
      #   }
      # }
      tags = {
        Pool = "core"
      }
    }
  }
}

## Cluster access
variable "cluster_access_map_users" {
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

## Cluster applications
variable "enable_metric_server" {
  type        = bool
  description = "Enable Metric Server"
  default     = true
}

variable "metric_server_helm_config" {
  type        = any
  default     = {}
  description = "Metric Server Helm Chart Configuration"
}

variable "enable_aws_node_termination_handler" {
  type        = bool
  default     = true
  description = "Enable AWS Node Termination Handler"
}

variable "aws_node_termination_handler_helm_config" {
  type        = any
  default     = {}
  description = "Node Termination handler Helm Chart Configuration"
}

variable "enable_aws_alb_controller" {
  type        = bool
  default     = false
  description = "Enable AWS Load Balancer Controller"
}

variable "aws_alb_controller_helm_config" {
  type        = any
  default     = {}
  description = "AWS Load Balancer Controller Helm Chart Configuration"
}

variable "enable_cluster_autoscaler" {
  type        = bool
  default     = true
  description = "Enable Cluster Autoscaler"
}

variable "cluster_autoscaler_helm_config" {
  type        = any
  default     = {}
  description = "Cluster Autoscaler Helm Chart Configuration"
}

variable "enable_cert_manager" {
  type        = bool
  default     = true
  description = "Enable Cert Manager"
}

variable "cert_manager_helm_config" {
  type        = any
  default     = {}
  description = "Cert Manager Helm Chart Configuration"
}

variable "install_letsencrypt_issuers" {
  type        = bool
  default     = true
  description = "Install Let's Encrypt Issuers"
}

variable "letsencrypt_email" {
  type        = string
  default     = "example@example.com"
  description = "Email address for expiration emails from Let's Encrypt."
}

variable "enable_ingress_nginx" {
  type        = bool
  default     = true
  description = "Enable Ingress Nginx"
}

variable "ingress_nginx_helm_config" {
  type        = any
  default     = {}
  description = "Ingress Nginx Helm Chart Configuration"
}

variable "enable_aws_ebs_csi_driver" {
  type        = bool
  default     = true
  description = "Enable AWS EBS CSI Driver"
}

variable "aws_ebs_csi_driver_helm_config" {
  type        = any
  default     = {}
  description = "AWS EBS csi driver Helm Chart Configuration"
}

# variable "enable_ecr" {
#   type        = bool
#   default     = true
#   description = "Enable ECR"
# }

variable "enable_gitlab_runner" {
  type        = bool
  default     = true
  description = "Enable Gitlab Runner"
}

variable "gitlab_runner_registration_token" {
  type        = string
  description = "Gitlab Runner Registration Token"
}

variable "gitlab_runner_tags" {
  type        = list(string)
  default     = ["aws"]
  description = "Gitlab Runner Helm Chart Configuration"
}

variable "gitlab_runner_additional_policy_arns" {
  type        = list(string)
  default     = []
  description = "Gitlab Runner Additional Policy ARNs"
}

variable "enable_calico" {
  type        = bool
  default     = false
  description = "Enable Calico"
}

variable "calico_helm_config" {
  type        = any
  default     = {}
  description = "Calico Helm Chart Configuration"
}

variable "enable_firestarter_operations" {
  type        = bool
  default     = false
  description = "Enable Firestarter Operations"
}

## Customer application
variable "customer_application" {
  type = map(object({
    namespaces   = list(string)
    repositories = optional(list(string), [])
  }))
}

## Velero
variable "enable_velero" {
  type        = bool
  default     = false
  description = "Enable Velero"
}

variable "velero_helm_config" {
  type        = any
  default     = {}
  description = "Velero Helm Chart Configuration"
}

variable "velero_helm_values" {
  type        = string
  default     = ""
  description = "Velero helm chart values"
}

variable "enable_velero_bucket_lifecycle" {
  type        = bool
  default     = true
  description = "Enable Velero Bucket Lifecycle"
}

variable "velero_bucket_infrequently_access_days" {
  type    = number
  default = 30
}

variable "velero_bucket_glacier_days" {
  type    = number
  default = 60
}

variable "velero_bucket_expiration_days" {
  type    = number
  default = 90
}
