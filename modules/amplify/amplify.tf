resource "aws_amplify_app" "this" {
  name         = "${var.name}-${var.environment}"
  repository   = var.repository
  access_token = var.github_access_token

  build_spec = var.build_spec

  # This needs to be first
  dynamic "custom_rule" {
    for_each = var.enable_www_subdomain ? [local.frontend_domain] : []

    content {
      source = "https://${custom_rule.value}"
      status = "302"
      target = "https://www.${custom_rule.value}"
    }
  }

  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|webp|woff|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }
}

resource "aws_amplify_branch" "this" {
  app_id      = aws_amplify_app.this.id
  branch_name = var.branch
  stage       = var.environment == "production" ? "PRODUCTION" : "BETA"
  framework   = "React"

  enable_auto_build = true

  environment_variables = merge(
    {
      AMPLIFY_DIFF_DEPLOY = false
    },
    var.environment_variables
  )
}

resource "aws_amplify_domain_association" "this" {
  count       = local.frontend_domain != null ? 1 : 0
  app_id      = aws_amplify_app.this.id
  domain_name = local.frontend_domain

  sub_domain {
    branch_name = aws_amplify_branch.this.branch_name
    prefix      = ""
  }

  dynamic "sub_domain" {
    for_each = var.enable_www_subdomain ? ["www"] : []
    content {
      branch_name = aws_amplify_branch.this.branch_name
      prefix      = "www"
    }
  }
}
