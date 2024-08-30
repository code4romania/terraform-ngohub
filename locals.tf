locals {
  isProduction = var.environment == "production"

  namespace  = "ngohub-${var.environment}"
  env_suffix = local.isProduction ? "" : "-${var.environment}"

  availability_zone = data.aws_availability_zones.current.names[1]

  db = {
    instance_class = "db.t4g.micro"
  }

  mail_domain = var.email_domain != null ? var.email_domain : var.root_domain
  mail_from   = "NGO Hub <no-reply@${local.mail_domain}>"

  ngohub = {
    namespace = "ngohub-${var.environment}"

    auth = {
      domain = "auth${local.env_suffix}.${var.root_domain}"
    }

    backend = {
      domain = "api${local.env_suffix}.${var.root_domain}"
      image = {
        repo = data.aws_ecr_repository.ngohub_backend.repository_url
        tag  = "1.0.32"
      }
    }

    frontend = {
      domain = "app${local.env_suffix}.${var.root_domain}"
    }
  }

  vic = {
    namespace = "vic-${var.environment}"

    auth = {
      domain = "auth-vic${local.env_suffix}.${var.root_domain}"
    }

    backend = {
      domain = "api-vic${local.env_suffix}.${var.root_domain}"
      image = {
        repo = data.aws_ecr_repository.vic_backend.repository_url
        tag  = "1.0.20"
      }
    }

    frontend = {
      domain = "vic${local.env_suffix}.${var.root_domain}"
    }
  }

  centrucivic = {
    frontend = {
      domain = local.isProduction ? "www.centrucivic.ro" : "centrucivic${local.env_suffix}.${var.root_domain}"
    }
  }

  practice4good = {
    frontend = {
      domain = local.isProduction ? "www.practice4good.ro" : "practice4good${local.env_suffix}.${var.root_domain}"
    }
  }
}
