variable "cluster_name" {
  type = string
}

variable "cluster_region" {
  type = string
}

variable "fluent_bit_image_tag" {
  type = string
}

variable "fluent_bit_enable_logs_collection" {
  type    = bool
  default = false
}

variable "fluent_bit_http_server" {
  type    = string
  default = "Off"
}

variable "fluent_bit_http_port" {
  type    = string
  default = ""
}

variable "fluent_bit_read_from_head" {
  type    = string
  default = "Off"
}

variable "fluent_bit_read_from_tail" {
  type    = string
  default = "On"
}

variable "fluent_bit_log_retention_days" {
  type    = number
  default = 14
}

variable "account_id" {
  type = string
}
