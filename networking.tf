module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.1.1"

  namespace = "ngohub"
  stage     = var.environment
  name      = "networking"

  ipv4_primary_cidr_block          = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = false
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.1"

  namespace = "ngohub"
  stage     = var.environment
  name      = "networking"

  availability_zones = data.aws_availability_zones.current.names
  vpc_id             = module.vpc.vpc_id
  igw_id             = [module.vpc.igw_id]
  ipv4_cidr_block    = [module.vpc.vpc_cidr_block]

  nat_gateway_enabled = true
  max_nats            = 1

  aws_route_create_timeout = "5m"
  aws_route_delete_timeout = "10m"
}
