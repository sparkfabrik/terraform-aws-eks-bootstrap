variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
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
      # db_name                      = optional(string, "")
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
