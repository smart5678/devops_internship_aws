variable "owner" {
  type    = string
}

variable "subnets" {
  type    = list(string)
}

variable "security_groups" {
  type = list(string)
  description = "SG for allow access to instance"
}

variable "vpc_id" {
  type = string
}

variable "username" {
  type = string
  sensitive = true
}

variable "password" {
  type = string
  sensitive = true
}

variable "private_key" {
  type = string
}

variable "key_name" {
  type = string
}