resource "aws_lb" "lb" {
  name = "yar"
  load_balancer_type = "application"
  internal = true

  security_groups = ["sg-???", "sg-???"]
  subnets = ["subnet-???", "subnet-???", "subnet-???"]

  tags {
    environment = "workshop"
    service = "test-service"
  }
}

resource "aws_lb_listener" "http" {
  "default_action" {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.tg.arn}"
  }

  load_balancer_arn = "${aws_lb.lb.arn}"
  port = 80
  protocol = "HTTP"
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
  name = "yar-name"
  port = 80
  protocol = "HTTP"
  vpc_id = "vpc-???"

  health_check {
    interval = 15
    timeout = 10
    healthy_threshold = 5
    unhealthy_threshold = 2
    matcher = 200
    path = "/management/health"
  }
}
