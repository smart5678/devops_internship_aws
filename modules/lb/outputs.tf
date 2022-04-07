output "lb_public_dns" {
  value = aws_lb.lb-ums.dns_name
}
