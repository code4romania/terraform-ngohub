locals {
  frontend_domain = var.enable_www_subdomain ? try(replace(var.frontend_domain, "/^www\\./", ""), null) : var.frontend_domain
}
