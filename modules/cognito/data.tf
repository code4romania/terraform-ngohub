data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "main" {
  name = var.root_domain
}

data "aws_ses_domain_identity" "this" {
  domain = var.email_domain
}
