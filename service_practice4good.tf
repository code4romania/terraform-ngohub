module "practice4good_amplify" {
  source = "./modules/amplify"

  name        = "practice4good"
  repository  = "https://github.com/code4romania/practice-for-good"
  branch      = "develop"
  environment = var.environment

  frontend_domain      = local.practice4good.frontend.domain
  enable_www_subdomain = local.isProduction

  github_access_token = var.github_access_token

  environment_variables = {
    REACT_APP_API_URL                 = "https://${local.ngohub.backend.domain}"
    REACT_APP_CREATE_ONG_PROFILE_LINK = "https://${local.ngohub.frontend.domain}/new"
  }
}
