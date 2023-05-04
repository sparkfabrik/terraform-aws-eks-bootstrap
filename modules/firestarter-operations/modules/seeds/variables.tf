variable "namespaces" {
  type = list(string)
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "aws_tags" {
  type        = map(string)
  default     = {}
  description = "Optional additional AWS tags"
}
