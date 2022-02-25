data "aws_route53_zone" "selected" {
  name = "destroyerohith.online"
  //private_zone = true
}

output "rzone" {
  value = data.aws_route53_zone.selected.zone_id
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.dns-name
  type    = "A"
  //sttl     = "300"
  //records = [aws_eip.nat.public_ip]
  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}