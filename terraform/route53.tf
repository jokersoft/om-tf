resource "aws_route53_record" "dns" {
  name    = "test-dns"
  type    = "CNAME"
  zone_id = "ZTT1QOMOLW2R7"
  ttl     = 60

  records = [
    "${aws_lb.lb.dns_name}",
  ]
}
