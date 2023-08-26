module "github" {
  source = "../../modules/github"

  id_provider_arn = local.id_provider_arn
}

module "site" {
  source = "../../modules/site"

  basicauth_username = local.basicauth_username
  basicauth_password = local.basicauth_password
}
