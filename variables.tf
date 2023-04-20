variable "aws_default_region" {
  type = string
}

################################################################################
# VPC Variables
################################################################################
variable "vpc" {
  type = object({
    cidr_block                = string
    azs                       = list(string)
    public_subnet_cidr_block  = list(string)
    private_subnet_cidr_block = list(string)
    service_subnet_cidr_block = list(string)
    enable_nat_gateway        = bool
    enable_single_nat_gateway = bool
  })
}

################################################################################
# EKS Variables
################################################################################

variable "cluster" {
  type = object({
    name    = string
    version = optional(string, "1.24")
    # Possible values: "api", "audit", "authenticator", "controllerManager", "scheduler"
    enabled_log_types = optional(list(string), [])
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
    autoscaler = optional(object({
      chart_version     = optional(string, "1.5.1")
      namespace         = optional(string, "kube-system")
      helm_release_name = optional(string, "aws-load-balancer-controller")
      }), {
      chart_version     = "1.5.1"
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
  })
}

variable "application_project" {
  type = map(object({
    repository_max_image = optional(number, 90)
    namespaces           = list(string)
    database = optional(object({
      engine                       = string
      engine_version               = string
      instance_class               = string
      storage_type                 = optional(string, "gp3")
      allocated_storage            = number
      max_allocated_storage        = number
      storage_encrypted            = optional(bool, true)
      multi_az                     = bool
      auto_minor_version_upgrade   = optional(string, true)
      db_name                      = optional(string, "")
      username                     = optional(string, "admin")
      password                     = optional(string, null)
      port                         = string
      snapshot_id                  = optional(string, null)
      maintenance_window           = optional(string, "sun:02:00-sun:05:00")
      apply_immediately            = optional(bool, true)
      backup_window                = optional(string, "00:00-01:00")
      backup_retention_period      = optional(string, "0")
      logs_exports                 = optional(list(string), ["error", "general", "slowquery"])
      publicly_accessible          = optional(bool, false)
      deletion_protection          = optional(bool, true)
      copy_tags_to_snapshot        = optional(bool, true)
      skip_final_snapshot          = optional(bool, true)
      performance_insights_enabled = optional(bool, false)
      # security_groups            = optional(list(string), [])
    }))
  }))
}

# variable "application_projects" {
#   description = "Application Project"
#   type = object({
#     name                 = string
#     repository_max_image = optional(number, 90)
#     namespace            = list(string)
#   })
# }
