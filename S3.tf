module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${data.aws_caller_identity.current.account_id}.my-state-bucket"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = false
  }
}
