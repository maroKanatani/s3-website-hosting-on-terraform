resource "aws_iam_role" "static_website_github_actions" {
  name               = "static-website-github-actions"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "static_website_github_actions" {
  role       = aws_iam_role.static_website_github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

data "aws_iam_policy_document" "assume_role_policy" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      identifiers = [var.id_provider_arn]
      type        = "Federated"
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:maroKanatani/s3-website-hosting-on-terraform:*"]
    }
  }
}

output "iam_role_arn" {
  value = aws_iam_role.static_website_github_actions.arn
}