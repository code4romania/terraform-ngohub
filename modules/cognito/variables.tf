variable "namespace" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  description = "Region where to deploy resources"
  type        = string
}

variable "root_domain" {
  description = "Root domain name"
  type        = string
}

variable "email_domain" {
  description = "Email domain name."
  type        = string
}

variable "auth_domain" {
  description = "Cognito domain name"
  type        = string
}

variable "backend_domain" {
  description = "Frontend domain name"
  type        = string
}

variable "frontend_domain" {
  description = "Frontend domain name"
  type        = string
}

variable "hmac_api_key" {
  description = "HMAC API Key"
  type        = string
  sensitive   = true
}

variable "hmac_secret_key" {
  description = "HMAC Secret Key"
  type        = string
  sensitive   = true
}

variable "certificate_arn" {
  type = string
}

variable "username_attributes" {
  type    = list(string)
  default = ["email"]
}

variable "auto_verified_attributes" {
  type    = list(string)
  default = []
}

variable "enable_localhost_urls" {
  description = "Add `http://localhost:3000` to allowed callback and logout urls"
  type        = bool
  default     = false
}

variable "ses_identiy_arn" {
  type = string
}

variable "enable_mfa" {
  description = "Enable MFA"
  type        = bool
  default     = false
}

variable "enforce_mfa" {
  description = "Set mfa_configuration to ON instead of OPTIONAL"
  type        = bool
  default     = false
}

variable "enable_sms" {
  description = "Enable SMS"
  type        = bool
  default     = false
}

variable "sms_external_id" {
  description = "External ID used in IAM role trust relationships."
  type        = string
  default     = "" # needs to be set to a non-null value for the module to work

  validation {
    condition     = can(regex("^[a-zA-Z0-9][-a-zA-Z0-9]{0,9}[a-zA-Z0-9]$", var.sms_external_id))
    error_message = "Maximum 11 alphanumeric or hyphen (-) characters, including at least one letter and no spaces. It has to start and end with an alphanumeric character."
  }
}

variable "facebook_provider_client_id" {
  description = "Facebook provider client id"
  type        = string
  default     = null
}

variable "facebook_provider_client_secret" {
  description = "Facebook provider client secret"
  type        = string
  default     = null
}

variable "google_provider_client_id" {
  description = "Google provider client id"
  type        = string
  default     = null
}

variable "google_provider_client_secret" {
  description = "Google provider client secret"
  type        = string
  default     = null
}

variable "ui_css" {
  description = "The CSS values in the UI customization, provided as a string."
  type        = string
  default     = null
}

variable "ui_logo" {
  description = "The uploaded logo image for the UI customization, provided as a base64-encoded String. Drift detection is not possible for this argument."
  type        = string
  default     = null
}

variable "extra_callback_urls" {
  type    = list(string)
  default = []
}

variable "email_contact" {
  description = "Email address where users can contact us."
  type        = string
  default     = null
}

variable "email_from" {
  description = "Email address where emails are sent from."
  type        = string
  default     = null
}

variable "email_assets_url" {
  type    = string
  default = null
}
