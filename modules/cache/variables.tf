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
    cache = optional(object({
      engine = string
      engine_version = string
      port = string
      node_type = string
      security_group_ids = optional(list(string), [])
      num_cache_nodes = optional(number, 1)
      az_mode = optional(string, "single-az")
    }))
  }))
}
