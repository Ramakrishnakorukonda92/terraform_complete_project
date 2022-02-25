module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "3.3.0"

  domain_name = data.aws_route53_zone.selected.name

  zone_id = data.aws_route53_zone.selected.zone_id

  subject_alternative_names = [
    "*.${data.aws_route53_zone.selected.name}"
  ]

  wait_for_validation = true

  tags = {
    Name = "mydomain"
  }
}


output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm.acm_certificate_arn

}

output "dname" {
  value = data.aws_route53_zone.selected.name
}
