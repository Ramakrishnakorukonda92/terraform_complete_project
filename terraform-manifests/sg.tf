module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

  name                = "new-sg"
  description         = "Security group with all available arguments set (this is just an example)"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]

}