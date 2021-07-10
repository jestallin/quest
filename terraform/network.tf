resource "aws_lb" "quest" {
  name               = "quest"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.quest.id]

  subnet_mapping {
    # us-east-1e
    subnet_id         = "subnet-f8900bc9"
  }

  subnet_mapping {
    subnet_id         = "${var.subnet-us-east-1b}"
  }
}

resource "aws_lb_listener" "http-quest" {
  load_balancer_arn = aws_lb.quest.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.quest.arn
  }
}

resource "aws_lb_listener" "https-quest" {
  load_balancer_arn = aws_lb.quest.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.cert-quest-jstallings-me}"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.quest.arn
  }
}

resource "aws_lb_target_group" "quest" {
  name     = "quest"
  port     = 3001
  protocol = "HTTP"
  vpc_id   = "${var.vpc-us-east-1}"
}

resource "aws_security_group" "quest" {
  name        = "quest"
  description = "quest sg"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "3001"
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform"
  }
}

resource "aws_lb_target_group_attachment" "quest" {
  target_group_arn = aws_lb_target_group.quest.arn
  target_id        = aws_instance.quest.id
  port             = 3001
}