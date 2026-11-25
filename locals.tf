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
        tag  = "2.0.3"
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
        # VIC 2.0 (own authentication): staging runs a vic release tag (v2.0.0-rc.N on develop);
        # production stays on 1.1.0 until vic_v2_enabled is set (service_vic.tf)
        tag = local.isProduction ? (local.vic_v2 ? var.vic_v2_image_tag : "1.1.0") : "2.0.0-rc.5"
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
