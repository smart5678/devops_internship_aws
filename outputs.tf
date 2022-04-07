output "public_data" {
  value = {
    worker_public_dns = module.worker.ec2_public_dns,
    mysql_address = module.mysql.rds_address,
    rds_endpoint = module.mysql.rds_endpoint,
    aws_instance_ids = module.worker.aws_instance_ids
    lb_public_dns = module.lb.lb_public_dns
  }
}