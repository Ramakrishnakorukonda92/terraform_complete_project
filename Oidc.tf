resource "aws_iam_openid_connect_provider" "default" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = ["1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}
module "iam_assumable_role_admin" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  create_role = true
  role_name   = "github_oidc"

  provider_url = "https://token.actions.githubusercontent.com"

  role_policy_arns = [
    aws_iam_policy.custom_oidc_v1.arn
  ]

  oidc_fully_qualified_subjects = [
    "repo:githubname/reponame:ref:refs/heads/test",
    "token.actions.githubusercontent.com:aud:sts.amazonaws.com"
  ]
}

data "aws_iam_policy_document" "custom_oidc_v1" {
  statement {
    sid       = "OidcBootStrap"
    actions   = ["s3:","iam:","dynamodb:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "custom_oidc_v1" {
  name_prefix = "custom-oidc-v1"
  #   path = "/terraform"
  policy = data.aws_iam_policy_document.custom_oidc_v1.json
}
