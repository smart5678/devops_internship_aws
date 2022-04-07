resource "aws_lb_target_group" "tg-ums-workers" {
  name     = "tg-ums-workers"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "tg-attachment-ums" {
  count                  = 2

  target_group_arn = aws_lb_target_group.tg-ums-workers.arn
  target_id        = var.aws_instance_ids[count.index]
  port             = 80
}

resource "aws_lb" "lb-ums" {
  name               = "lb-ums"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Environment = "production"
    Owner = var.owner_tag
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb-ums.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-ums-workers.arn
  }
}