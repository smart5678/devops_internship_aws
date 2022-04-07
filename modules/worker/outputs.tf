output "ec2_public_dns" {
  value = aws_instance.ec2_ums_worker[*].public_dns
}

output "aws_instance_ids" {
  value = aws_instance.ec2_ums_worker[*].id
}