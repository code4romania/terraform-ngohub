variable "name" {
  type = string
}

variable "repository" {
  type = string
}
variable "branch" {
  type    = string
  default = "develop"
}

variable "environment" {
  type = string
}

variable "github_access_token" {
  type = string
}

variable "environment_variables" {
  type = map(string)
}

variable "frontend_domain" {
  type    = string
  default = null
}

variable "build_spec" {
  type    = string
  default = null
}
