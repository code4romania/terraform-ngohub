locals {
  namespace  = "ngohub-${var.environment}"
  env_suffix = var.environment == "production" ? "" : "-${var.environment}"

  availability_zone = data.aws_availability_zones.current.names[1]

  db = {
    instance_class = "db.t4g.micro"
  }

  mail = {
    domain = var.email_domain != null ? var.email_domain : var.root_domain
  }

  ngohub = {
    auth = {
      domain = "auth${local.env_suffix}.${var.root_domain}"
    }

    backend = {
      domain = "api${local.env_suffix}.${var.root_domain}"
      image  = "${data.aws_ecr_repository.ngohub_backend.repository_url}:${var.ngohub_backend_tag}"
    }

    frontend = {
      domain = "app${local.env_suffix}.${var.root_domain}"
    }
  }

  vic = {
    auth = {
      domain = "auth-vic${local.env_suffix}.${var.root_domain}"
    }

    backend = {
      domain = "api-vic${local.env_suffix}.${var.root_domain}"
    }

    frontend = {
      domain = "vic${local.env_suffix}.${var.root_domain}"
    }
  }

  centrucivic = {
    frontend = {
      domain = "centrucivic${local.env_suffix}.${var.root_domain}"
    }
  }

  practice4good = {
    frontend = {
      domain = "practice4good${local.env_suffix}.${var.root_domain}"
    }
  }
}
