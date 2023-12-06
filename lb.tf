resource "aws_lb" "main" {
  name               = "${local.namespace}-lb"
  load_balancer_type = "application"
  subnets            = module.subnets.public_subnet_ids
  security_groups    = [aws_security_group.lb.id]
}

resource "aws_lb_listener" "https" {
  certificate_arn   = aws_acm_certificate.regional.arn
  load_balancer_arn = aws_lb.main.id
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_security_group" "lb" {
  name        = "${local.namespace}-lb-sg"
  description = "Inbound - Security Group attached to the Application Load Balancer (${var.environment})"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
