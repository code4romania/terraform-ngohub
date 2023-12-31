module "centrucivic_amplify" {
  source = "./modules/amplify"

  name        = "centrucivic"
  repository  = "https://github.com/code4romania/centrucivic"
  branch      = local.isProduction ? "main" : "develop"
  environment = var.environment

  frontend_domain      = local.centrucivic.frontend.domain
  enable_www_subdomain = local.isProduction

  github_access_token = var.github_access_token

  environment_variables = {
    REACT_APP_API_URL                 = "https://${local.ngohub.backend.domain}"
    REACT_APP_CREATE_ONG_PROFILE_LINK = "https://${local.ngohub.frontend.domain}/new"
    REACT_APP_P4G_LINK                = "https://${local.practice4good.frontend.domain}"
  }
}
