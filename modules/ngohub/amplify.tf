resource "aws_amplify_app" "this" {
  name       = local.namespace
  repository = "https://github.com/code4romania/onghub"

  access_token = var.github_access_token

  build_spec = file("${path.module}/amplify/amplify.yml")

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
  branch_name = "develop"
  stage       = var.environment == "production" ? "PRODUCTION" : "BETA"
  framework   = "React"

  enable_auto_build = true

  environment_variables = {
    AMPLIFY_DIFF_DEPLOY            = false
    AMPLIFY_MONOREPO_APP_ROOT      = "frontend"
    REACT_APP_API_URL              = "https://${var.backend_domain}"
    REACT_APP_AWS_REGION           = var.region
    REACT_APP_COGNITO_OAUTH_DOMAIN = aws_cognito_user_pool_domain.custom.domain # "${aws_cognito_user_pool_domain.domain.domain}.auth.${var.region}.amazoncognito.com"
    REACT_APP_FRONTEND_URL         = "https://${var.frontend_domain}"
    REACT_APP_USER_POOL_CLIENT_ID  = aws_cognito_user_pool_client.this.id
    REACT_APP_USER_POOL_ID         = aws_cognito_user_pool.this.id
  }
}

resource "aws_amplify_domain_association" "this" {
  app_id      = aws_amplify_app.this.id
  domain_name = var.frontend_domain

  sub_domain {
    branch_name = aws_amplify_branch.this.branch_name
    prefix      = ""
  }
}
