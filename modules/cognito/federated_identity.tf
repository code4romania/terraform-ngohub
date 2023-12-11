resource "aws_cognito_identity_provider" "facebook" {
  count         = var.facebook_provider_client_id != null ? 1 : 0
  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = "Facebook"
  provider_type = "Facebook"

  provider_details = {
    authorize_scopes = "public_profile, email"
    client_id        = var.facebook_provider_client_id
    client_secret    = var.facebook_provider_client_secret

    # Prevent default values null cycle
    # @see https://github.com/hashicorp/terraform-provider-aws/issues/4831#issuecomment-871729220
    attributes_url                = "https://graph.facebook.com/v17.0/me?fields="
    attributes_url_add_attributes = true
    authorize_url                 = "https://www.facebook.com/v17.0/dialog/oauth"
    token_request_method          = "GET"
    token_url                     = "https://graph.facebook.com/v17.0/oauth/access_token"
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

    # Prevent default values null cycle
    # @see https://github.com/hashicorp/terraform-provider-aws/issues/4831#issuecomment-871729220
    attributes_url                = "https://people.googleapis.com/v1/people/me?personFields="
    attributes_url_add_attributes = true
    authorize_url                 = "https://accounts.google.com/o/oauth2/v2/auth"
    oidc_issuer                   = "https://accounts.google.com"
    token_request_method          = "POST"
    token_url                     = "https://www.googleapis.com/oauth2/v4/token"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}

# resource "aws_cognito_identity_provider" "apple" {
#   count         = var.google_provider_client_id != null ? 1 : 0
#   user_pool_id  = aws_cognito_user_pool.this.id
#   provider_name = "Apple"
#   provider_type = "Apple"

#   provider_details = {
#     authorize_scopes = "public_profile, email"
#     client_id        = var.google_provider_client_id
#     client_secret    = var.google_provider_client_secret
#   }

#   attribute_mapping = {
#     email    = "email"
#     username = "id"
#   }
# }
