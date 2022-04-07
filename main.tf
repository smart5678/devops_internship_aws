terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Owner = var.owner
    }
  }
}

#module "control" {
#  source      = "./modules/control"
##  user_data = file("./scripts/control.sh")
#}

module "worker" {
  source      = "./modules/worker"
  subnets = var.subnets
  mysql_address = module.mysql.rds_address
  security_groups = var.security_groups
  password = var.password
  username = var.username
  owner_tag = var.owner
  private_key = var.private_key
  key_name = var.key_name
}

module "lb" {
  source      = "./modules/lb"
  subnets = var.subnets
  aws_instance_ids = module.worker.aws_instance_ids
  owner_tag = var.owner
  security_groups = var.security_groups
}

module "mysql" {
  source      = "./modules/rds"
  security_groups = var.security_groups
  username               = var.username
  password               = var.password
}