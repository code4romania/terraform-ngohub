resource "aws_elasticache_cluster" "redis" {
  cluster_id           = local.namespace
  engine               = "redis"
  node_type            = "cache.t4g.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  az_mode              = "single-az"

  subnet_group_name  = aws_elasticache_subnet_group.elasticache_subnet_group.name
  security_group_ids = [aws_security_group.elasticache.id]
}

resource "aws_security_group" "elasticache" {
  name        = "${local.namespace}-elasticache"
  description = "Inbound - Security Group attached to the elasticache cluster"
  vpc_id      = module.vpc.vpc_id


  ingress {
    from_port   = "6379"
    to_port     = "6379"
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name       = "${local.namespace}-elasticache-private"
  subnet_ids = [module.subnets.private_subnet_ids[1]]

  tags = {
    access = "private"
  }
}
