module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name     = "${data.aws_caller_identity.current.account_id}-my-table"
  hash_key = "LockID"

  attributes = [
    {
      name = "LockID"
      type = "N"
    }
  ]
}
