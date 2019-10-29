resource "aws_route53_record" "dns" {
  name = "test"
  type = "CNAME"
  zone_id = "???"
  ttl = 60

  records = [
    "${aws_lb.lb.dns_name}"
  ]
}
