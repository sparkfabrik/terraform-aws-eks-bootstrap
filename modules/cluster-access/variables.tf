# variable "namespaces" {
#   type = list(string)
# }

variable "developer_group_name" {
  type    = string
  default = "developer-access"
}

variable "admin_group_name" {
  type    = string
  default = "admin-access"
}

variable "customer_application" {
  type = map(object({
    namespaces = list(string)
    repositories = optional(list(string), [])
  }))
}
