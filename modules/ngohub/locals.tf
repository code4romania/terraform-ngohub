locals {
  namespace  = "ngohub-${var.env}"
  env_suffix = var.env == "production" ? "" : "-${var.env}"

  frontend = {
    domain = "app${local.env_suffix}.${var.root_domain}"
  }

  backend = {
    domain = "api${local.env_suffix}.${var.root_domain}"
    image  = "${var.image_repo}:${var.image_tag}"
  }

  mail = {
    domain = try(var.email_domain, var.root_domain)
  }
}
