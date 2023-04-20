variable "cluster_name" {
  type = string
}

variable "application_project" {
  type = map(object({
    repository_max_image = optional(number, 90)
    namespaces           = list(string)
  }))
}
