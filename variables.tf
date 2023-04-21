variable "aws_default_region" {
  type        = string
  description = "AWS default region"
}

variable "project" {
  type        = string
  description = "Project name"
}

################################################################################
# EKS Variables
################################################################################

variable "cluster" {
  type = object({
    name                           = string
    version                        = optional(string, "1.24")
    enable_endpoint_public_access  = optional(bool, true)
    enable_endpoint_private_access = optional(bool, true)
    log_group_retention_in_days    = optional(number, 14)
    enabled_log_types              = optional(list(string), []) # Possible values: "api", "audit", "authenticator", "controllerManager", "scheduler"
    eks_managed_node_group_defaults = optional(object({
      instance_types = optional(list(string), ["t3.medium"])
      disk_size      = optional(number, 50)
      desired_size   = optional(number, 2)
      }), {
      instance_types = ["t3.medium"]
      disk_size      = 50
      desired_size   = 2
    })
    eks_managed_node_groups = optional(map(object({
      min_size       = optional(number, 1)
      max_size       = optional(number, 3)
      desired_size   = optional(number, 2)
      instance_types = optional(list(string), ["t3.small"])
      capacity_type  = optional(string, "SPOT")
      labels = optional(map(string), {
        role = "default"
      })
      })), {
      default = {
        min_size       = 1
        max_size       = 3
        desired_size   = 2
        instance_types = ["t3.small"]
        capacity_type  = "SPOT"
        labels = {
          role = "default"
        }
      }
    })
    # Cluster Autoscaler https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler
    autoscaler = optional(object({
      chart_version     = optional(string, "9.28.0")
      namespace         = optional(string, "kube-system")
      helm_release_name = optional(string, "cluster-autoscaler")
      }), {
      chart_version     = "9.28.0"
      namespace         = "kube-system"
      helm_release_name = "cluster-autoscaler"
    })
    # ALB Ingress Controller https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
    alb_controller = optional(object({
      chart_version     = optional(string, "1.5.2")
      namespace         = optional(string, "kube-system")
      helm_release_name = optional(string, "aws-load-balancer-controller")
      }), {
      chart_version     = "1.5.2"
      namespace         = "kube-system"
      helm_release_name = "aws-load-balancer-controller"
    })
    # Node Termination Handler https://artifacthub.io/packages/helm/aws/aws-node-termination-handler
    node_termination_handler = optional(object({
      chart_version     = optional(string, "0.21.0")
      namespace         = optional(string, "kube-system")
      helm_release_name = optional(string, "aws-node-termination-handler")
      }), {
      chart_version     = "0.21.0"
      namespace         = "kube-system"
      helm_release_name = "aws-node-termination-handler"
    })
    cluster_access = optional(object({
      enable               = optional(bool, true)
      developer_group_name = optional(string, "developer-access")
      admin_group_name     = optional(string, "admin-access")
      environment          = optional(string, "prod")
      namespaces           = optional(list(string), ["default"])
      }), {
      enable               = true
      developer_group_name = "developer-access"
      admin_group_name     = "admin-access"
      environment          = "prod"
    })
    # Cert Manager https://artifacthub.io/packages/helm/jetstack/cert-manager
    cert_manager = optional(object({
      chart_version               = optional(string, "1.11.1")
      namespace                   = optional(string, "cert-manager")
      helm_release_name           = optional(string, "cert-manager")
      cluster_issuer_name         = optional(string, "letsencrypt-prod")
      secret_name                 = optional(string, "letsencrypt-prod")
      staging_cluster_issuer_name = optional(string, "letsencrypt-staging")
      staging_secret_name         = optional(string, "letsencrypt-staging")
      email                       = optional(string, "example@example.com")
      install_cluster_issuer      = optional(bool, true)
      }), {
      chart_version               = "1.11.1"
      namespace                   = "cert-manager"
      helm_release_name           = "cert-manager"
      cluster_issuer_name         = "letsencrypt-prod"
      secret_name                 = "letsencrypt-prod"
      staging_cluster_issuer_name = "letsencrypt-staging"
      staging_secret_name         = "letsencrypt-staging"
      email                       = "example@example.com"
      install_cluster_issuer      = true
    })
    # Metrics Server https://artifacthub.io/packages/helm/metrics-server/metrics-server
    metrics_server = optional(object({
      chart_version     = optional(string, "3.10.0")
      namespace         = optional(string, "metrics-server")
      helm_release_name = optional(string, "metrics-server")
      }), {
      chart_version     = "3.10.0"
      namespace         = "metrics-server"
      helm_release_name = "metrics-server"
    })
    ingress_nginx = optional(object({
      chart_version     = optional(string, "4.6.0")
      namespace         = optional(string, "ingress-nginx")
      helm_release_name = optional(string, "ingress-nginx")
      aws_tags          = optional(map(string), {})
      nlb_name          = optional(string, "ingress-nginx-nlb")
      }), {
      chart_version     = "3.36.0"
      namespace         = "ingress-nginx"
      helm_release_name = "ingress-nginx"
      aws_tags          = {}
    })
    fluentbit = optional(object({
      fluent_bit_image_tag              = optional(string, "2.21.6")
      fluent_bit_enable_logs_collection = optional(bool, false)
      fluent_bit_http_server            = optional(string, "Off")
      fluent_bit_http_port              = optional(string, "")
      fluent_bit_read_from_head         = optional(string, "Off")
      fluent_bit_read_from_tail         = optional(string, "On")
      fluent_bit_log_retention_days     = optional(number, 14)
      namespace                         = optional(string, "amazon-cloudwatch")
      }), {
      fluent_bit_image_tag              = "1.8.10"
      fluent_bit_enable_logs_collection = false
      fluent_bit_http_server            = "Off"
      fluent_bit_http_port              = ""
      fluent_bit_read_from_head         = "Off"
      fluent_bit_read_from_tail         = "On"
      fluent_bit_log_retention_days     = 14
      namespace                         = "amazon-cloudwatch"
    })
  })
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "account_id" {
  type        = string
  description = "AWS Account ID"
}
