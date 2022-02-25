module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.4.0"

  depends_on = [
    module.vpc
  ]
  name = "${local.name}-sample-public-instance"

  ami           = data.aws_ami.amazonlinux.id
  instance_type = var.instance_type
  key_name      = "newkey"
  //monitoring             = true
  vpc_security_group_ids = [module.security-group.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data              = file("nginx.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }


}

