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
