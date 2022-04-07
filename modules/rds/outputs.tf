output "rds_address" {
  value = aws_db_instance.mysql.address
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}