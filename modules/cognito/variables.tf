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
