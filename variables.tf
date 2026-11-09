variable "environment" {
  type = string

  validation {
    condition     = contains(["production", "staging", "development"], var.environment)
    error_message = "Allowed values for env are \"production\", \"staging\" or \"development\"."
  }
}

variable "region" {
  description = "Region where to deploy resources."
  type        = string
  default     = "eu-west-1"
}

variable "bastion_public_key" {
  description = "Public SSH key used to connect to the bastion."
  type        = string
}

variable "root_domain" {
  description = "Root domain name."
  type        = string
}

variable "email_domain" {
  description = "[optional] Email domain name, defaults to the root domain name."
  type        = string
  default     = null
}

variable "email_contact" {
  description = "Email address where users can contact us."
  type        = string
  default     = null
}

variable "create_iam_service_linked_role" {
  description = "Whether to create `AWSServiceRoleForECS` service-linked role. Set it to `false` if you already have an ECS cluster created in the AWS account and AWSServiceRoleForECS already exists."
  type        = bool
  default     = false
}

variable "ngohub_hmac_api_key" {
  type      = string
  sensitive = true
}

variable "ngohub_hmac_secret_key" {
  type      = string
  sensitive = true
}

variable "ngohub_hmac_encryption_key" {
  type      = string
  sensitive = true
}

variable "github_access_token" {
  type      = string
  sensitive = true
}

variable "expo_push_notifications_access_token" {
  type      = string
  sensitive = true
}

variable "vic_facebook_provider_client_id" {
  description = "Facebook provider client id"
  type        = string
  default     = null
}

variable "vic_facebook_provider_client_secret" {
  description = "Facebook provider client secret"
  type        = string
  default     = null
  sensitive   = true
}
variable "vic_google_provider_client_id" {
  description = "Google provider client id"
  type        = string
  default     = null
}

variable "vic_google_provider_client_secret" {
  description = "Google provider client secret"
  type        = string
  default     = null
  sensitive   = true
}

variable "ngohub_landing_url" {
  description = "URL to the landing page of the NGOHub (the one with Website Factory)."
  type        = string
  default     = null
}

variable "sentry_dsn_ngohub" {
  type      = string
  sensitive = true
  default   = null
}

variable "sentry_dsn_vic" {
  type      = string
  sensitive = true
  default   = null
}

variable "staging_auth_credentials" {
  description = "Basic auth credentials for amplify staging environment."
  type        = string
  sensitive   = true
  default     = null
}

# VIC 2.0: own authentication (magic link). Secrets go in the workspace as sensitive variables.
variable "vic_jwt_private_key" {
  description = "VIC JWT signing key: RSA private key PEM, base64 encoded on one line."
  type        = string
  sensitive   = true
}

variable "vic_jwt_public_key" {
  description = "VIC JWT public key PEM, base64 encoded on one line."
  type        = string
  sensitive   = true
}

variable "vic_jwt_key_id" {
  description = "VIC JWT key id (kid), e.g. vic-staging-2026-11."
  type        = string
}

variable "vic_auth_token_key" {
  description = "VIC key for login codes and links: 32 random bytes, base64."
  type        = string
  sensitive   = true
}

variable "vic_turnstile_secret" {
  description = "Cloudflare Turnstile secret for the VIC NGO registration form."
  type        = string
  sensitive   = true
}

variable "vic_turnstile_site_key" {
  description = "Cloudflare Turnstile site key for the VIC web app."
  type        = string
}

variable "vic_google_client_ids" {
  description = "Google OAuth client ids accepted by the VIC backend, comma separated (iOS, Android, web)."
  type        = string
  default     = ""
}

variable "vic_apple_bundle_id" {
  description = "Apple bundle id accepted for Sign in with Apple."
  type        = string
  default     = "org.commitglobal.vic"
}

variable "vic_mobile_min_version" {
  description = "Oldest VIC mobile app version the API accepts (older apps get 426 and an update screen)."
  type        = string
  default     = "1.0.19"
}

variable "vic_maintenance_mode" {
  description = "\"true\" answers 503 to everyone except vic_maintenance_allowed_ips."
  type        = string
  default     = "false"
}

variable "vic_maintenance_allowed_ips" {
  description = "IPs allowed through maintenance mode, comma separated."
  type        = string
  default     = ""
  sensitive   = true
}

variable "vic_app_store_url" {
  description = "VIC app link in the App Store (web: update notice)."
  type        = string
  default     = ""
}

variable "vic_play_store_url" {
  description = "VIC app link in Google Play (web: update notice)."
  type        = string
  default     = "https://play.google.com/store/apps/details?id=org.commitglobal.vic"
}

variable "vic_migration_notice_until" {
  description = "Date (YYYY-MM-DD) until the web shows the VIC 2.0 migration notice; empty hides it."
  type        = string
  default     = ""
}

variable "vic_google_web_client_id" {
  description = "Google OAuth web client id used by the VIC web app (Google sign-in button)."
  type        = string
  default     = ""
}

variable "vic_apple_services_id" {
  description = "Apple Services ID for Sign in with Apple on the VIC web app."
  type        = string
  default     = ""
}

variable "vic_apple_team_id" {
  description = "Apple Developer team id (Sign in with Apple)."
  type        = string
  default     = ""
}

variable "vic_apple_key_id" {
  description = "Key id of the Sign in with Apple private key."
  type        = string
  default     = ""
}

variable "vic_apple_private_key" {
  description = "Sign in with Apple private key (.p8), PEM."
  type        = string
  sensitive   = true
  default     = ""
}
