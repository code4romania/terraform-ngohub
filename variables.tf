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

variable "ngohub_backend_repo" {
  description = "Docker image repository."
  type        = string
  default     = null
}

variable "ngohub_backend_tag" {
  description = "Docker image tag."
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

variable "create_iam_service_linked_role" {
  description = "Whether to create `AWSServiceRoleForECS` service-linked role. Set it to `false` if you already have an ECS cluster created in the AWS account and AWSServiceRoleForECS already exists."
  type        = bool
  default     = false
}

variable "ngohub_hmac_api_key" {
  type = string
}

variable "ngohub_hmac_secret_key" {
  type = string
}
variable "ngohub_hmac_encryption_key" {
  type = string
}

variable "github_access_token" {
  type = string
}
