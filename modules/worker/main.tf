resource "aws_instance" "ec2_ums_worker" {
  count                  = 2
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = var.security_groups

  tags = {
    Name  = "ec2_ums_task2_worker_instance"
    Owner = var.owner_tag
  }

  volume_tags = {
    "Owner" = var.owner_tag
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key)
    host        = self.public_dns
  }
  subnet_id = var.subnets[count.index]

  provisioner "remote-exec" {
    script = "./scripts/wordpress.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo Make wp-config.php",
      "sed -i \"s/.*DB_HOST.*/define('DB_HOST', '${var.mysql_address}');/\" /var/www/html/wp-config.php",
      "sed -i \"s/.*DB_NAME.*/define('DB_NAME', 'wordpress');/\" /var/www/html/wp-config.php",
      "sed -i \"s/.*DB_USER.*/define('DB_USER', '${var.username}');/\" /var/www/html/wp-config.php",
      "sed -i \"s/.*DB_PASSWORD.*/define('DB_PASSWORD', '${var.password}');/\" /var/www/html/wp-config.php",
    ]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
  owners = ["amazon"]
}


