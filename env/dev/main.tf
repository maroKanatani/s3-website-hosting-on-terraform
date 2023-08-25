module "site" {
  source = "../../modules/site"

  basicauth_username = local.basicauth_username
  basicauth_password = local.basicauth_password
}
