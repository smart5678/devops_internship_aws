variable "owner_tag" {
  type    = string
}

variable "security_groups" {
  type = list(string)
  description = "SG for allow access to instance"
}

variable "subnets" {
  type = list(string)
  description = "Subnets for worker instances"
}

variable "mysql_address" {
  type = string
  description = "mysql_address"
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