variable "security_groups" {
  type = list(string)
  description = "SG for allow access to instance"
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}


