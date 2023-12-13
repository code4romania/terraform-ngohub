resource "aws_cognito_user_pool" "this" {
  name = var.namespace

  # When active, DeletionProtection prevents accidental deletion of your user pool.
  # Currently active only in production
  deletion_protection = var.environment == "production" ? "ACTIVE" : "INACTIVE"

  username_attributes      = var.username_attributes
  auto_verified_attributes = var.auto_verified_attributes

  username_configuration {
    case_sensitive = false
  }

  sms_authentication_message = "Your verification code is {####}."

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_message        = "Your verification code is {####}. "
    email_subject        = "Your verification code"
    sms_message          = "Your verification code is {####}. "
  }


  mfa_configuration = var.enable_mfa ? (var.enforce_mfa ? "ON" : "OPTIONAL") : "OFF"
  dynamic "software_token_mfa_configuration" {
    for_each = var.enable_mfa ? [1] : []
    content {
      enabled = true
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = true

    invite_message_template {
      email_message = "Your username is {username} and temporary password is {####}. "
      email_subject = "Your temporary password"
      sms_message   = "Your username is {username} and temporary password is {####}. "
    }
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  dynamic "sms_configuration" {
    for_each = var.enable_sms ? [1] : []
    content {
      external_id    = var.sms_external_id
      sns_caller_arn = aws_iam_role.cognito_sms_role[0].arn
      sns_region     = var.region
    }
  }


  email_configuration {
    email_sending_account = "DEVELOPER"
    source_arn            = var.ses_identiy_arn
    from_email_address    = var.email_from
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 30
  }

  lambda_config {
    create_auth_challenge          = aws_lambda_function.amplify_login_create_auth_challenge.arn
    define_auth_challenge          = aws_lambda_function.amplify_login_define_auth_challenge.arn
    verify_auth_challenge_response = aws_lambda_function.amplify_login_verify_auth_challenge_response.arn
    custom_message                 = aws_lambda_function.amplify_login_custom_message.arn
  }
}

resource "aws_cognito_user_pool_client" "this" {
  name         = var.namespace
  user_pool_id = aws_cognito_user_pool.this.id

  callback_urls = compact(concat(
    [
      "https://${var.frontend_domain}",
      var.enable_localhost_urls ? "http://localhost:3000" : null,
    ],
    var.extra_callback_urls
  ))

  logout_urls = compact(concat(
    [
      "https://${var.frontend_domain}",
      var.enable_localhost_urls ? "http://localhost:3000" : null,
    ],
    var.extra_callback_urls
  ))

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  supported_identity_providers = compact([
    "COGNITO",
    try(aws_cognito_identity_provider.facebook[0].provider_name, null),
    try(aws_cognito_identity_provider.google[0].provider_name, null),
  ])
  allowed_oauth_scopes = [
    "aws.cognito.signin.user.admin",
    "email",
    "openid",
    "profile",
  ]

  prevent_user_existence_errors = "ENABLED"

  enable_propagate_additional_user_context_data = false
  enable_token_revocation                       = true

  explicit_auth_flows = [
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]
}

resource "aws_cognito_user_pool_ui_customization" "this" {
  count        = var.ui_css != null || var.ui_logo != null ? 1 : 0
  css          = var.ui_css
  image_file   = var.ui_logo
  user_pool_id = aws_cognito_user_pool.this.id
  depends_on   = [aws_cognito_user_pool_domain.custom]
}

resource "aws_cognito_user_pool_domain" "default" {
  domain       = var.namespace
  user_pool_id = aws_cognito_user_pool.this.id
}

resource "aws_cognito_user_pool_domain" "custom" {
  domain          = var.auth_domain
  certificate_arn = var.certificate_arn
  user_pool_id    = aws_cognito_user_pool.this.id
}

resource "aws_route53_record" "auth-cognito-A" {
  name    = aws_cognito_user_pool_domain.custom.domain
  type    = "A"
  zone_id = data.aws_route53_zone.main.zone_id

  alias {
    evaluate_target_health = false

    name    = aws_cognito_user_pool_domain.custom.cloudfront_distribution
    zone_id = aws_cognito_user_pool_domain.custom.cloudfront_distribution_zone_id
  }
}

resource "aws_route53_record" "auth-cognito-AAAA" {
  name    = aws_cognito_user_pool_domain.custom.domain
  type    = "AAAA"
  zone_id = data.aws_route53_zone.main.zone_id

  alias {
    evaluate_target_health = false

    name    = aws_cognito_user_pool_domain.custom.cloudfront_distribution
    zone_id = aws_cognito_user_pool_domain.custom.cloudfront_distribution_zone_id
  }
}
