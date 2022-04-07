variable "owner_tag" {
  type    = string
}

variable "vpc_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
  description = "SG for allow access to instance"
}

variable "subnets" {
  type = list(string)
  description = "Subnets for worker instances"
}

variable "aws_instance_ids" {
  type = list(string)
  description = "aws_instance_ids"
}
