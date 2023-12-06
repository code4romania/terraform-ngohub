data "aws_ecr_repository" "ngohub_backend" {
  name = "onghub"
}

data "aws_availability_zones" "current" {
  state = "available"
}

data "aws_route53_zone" "main" {
  name = var.root_domain
}
