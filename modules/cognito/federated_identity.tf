resource "aws_cognito_identity_provider" "facebook" {
  count         = var.facebook_provider_client_id != null ? 1 : 0
  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = "Facebook"
  provider_type = "Facebook"

  provider_details = {
    authorize_scopes = "public_profile, email"
    client_id        = var.facebook_provider_client_id
    client_secret    = var.facebook_provider_client_secret
  }

  attribute_mapping = {
    email    = "email"
    username = "id"
  }
}

resource "aws_cognito_identity_provider" "google" {
  count         = var.google_provider_client_id != null ? 1 : 0
  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "profile email openid"
    client_id        = var.google_provider_client_id
    client_secret    = var.google_provider_client_secret
  }

  attribute_mapping = {
    email = "email"
    # username = "id"
  }
}
