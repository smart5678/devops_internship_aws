resource "aws_db_instance" "mysql" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7.16"
  instance_class         = "db.t2.micro"
  db_name                = "wordpress"
  username               = var.username
  password               = var.password
  skip_final_snapshot    = true
  vpc_security_group_ids = var.security_groups
}
