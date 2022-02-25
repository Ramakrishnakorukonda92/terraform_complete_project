# locals {
#   name   = "terraform-example"
#   region = "us-east-1"
#   tags = {
#     Owner       = "user"
#     Environment = "staging"
#     Name        = "complete"
#   }
# }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  name = var.name
  cidr = "20.10.0.0/16" # 10.0.0.0/8 is reserved for EC2-Classic

  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets  = ["20.10.1.0/24", "20.10.2.0/24", "20.10.3.0/24"]
  public_subnets   = ["20.10.11.0/24", "20.10.12.0/24", "20.10.13.0/24"]
  database_subnets = ["20.10.21.0/24", "20.10.22.0/24", "20.10.23.0/24"]

  create_database_subnet_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  //tags = local.tags
}

