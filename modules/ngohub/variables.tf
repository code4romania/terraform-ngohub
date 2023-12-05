variable "env" {
  description = "Environment"
  type        = string

  validation {
    condition     = contains(["production", "staging", "development"], var.env)
    error_message = "Allowed values for env are \"production\", \"staging\" or \"development\"."
  }
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
  description = "[optional] Email domain name, defaults to the root domain name."
  type        = string
  default     = null
}

variable "image_repo" {
  type = string
}

variable "image_tag" {
  type = string
}
