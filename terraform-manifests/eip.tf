resource "aws_eip" "nat" {
  instance = module.ec2-instance.id
}