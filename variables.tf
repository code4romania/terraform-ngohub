variable "env" {
  description = "Environment"
  type        = string

  validation {
    condition     = contains(["production", "staging", "development"], var.env)
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
