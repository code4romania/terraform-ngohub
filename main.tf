module "ngohub" {
  source = "./modules/ngohub"

  env         = var.env
  region      = var.region
  image_repo  = try(var.ngohub_backend_repo, data.aws_ecr_repository.ngohub_backend.repository_url)
  image_tag   = var.ngohub_backend_tag
  root_domain = var.root_domain
}

# module "vpc" {
#   source  = "cloudposse/vpc/aws"
#   version = "2.1.1"

#   namespace = "ngohub"
#   stage     = var.env

#   ipv4_primary_cidr_block          = "10.0.0.0/16"
#   assign_generated_ipv6_cidr_block = false
# }
