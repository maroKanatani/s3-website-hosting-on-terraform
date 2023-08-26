locals {
  id_provider_arn    = "arn:aws:iam::${var.account_id}:oidc-provider/${var.github_actions_role_name}"
  basicauth_username = "user"
  basicauth_password = "pass"
}