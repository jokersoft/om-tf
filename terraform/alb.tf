resource "aws_lb" "lb" {
  name               = "test-lb"
  load_balancer_type = "application"
  internal           = true

  security_groups = ["sg-b60e82dd"]
  subnets         = ["subnet-09644a43", "subnet-838dd3eb", "subnet-f4d1b48e"]

  tags {
    environment = "default"
    service     = "test-service"
  }
}

resource "aws_lb_listener" "http" {
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg.arn}"
  }

  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = 80
  protocol          = "HTTP"
}

//resource "aws_lb_listener" "https" {
//  "default_action" {
//    type = "forward"
//    target_group_arn = "${aws_lb_target_group.tg.arn}"
//  }
//
//  load_balancer_arn = "${aws_lb.lb.arn}"
//  port = 443
//  protocol = "HTTPS"
//}

resource "aws_lb_target_group" "tg" {
  name     = "test-tg"
  port     = 32769
  protocol = "HTTP"
  vpc_id   = "vpc-a171ecc9"

  health_check {
    interval            = 15
    timeout             = 10
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = 200

    //    path                = "/management/health"
    path = "/"
  }
}
