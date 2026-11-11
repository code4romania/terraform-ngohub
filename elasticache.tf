resource "aws_elasticache_cluster" "redis" {
  cluster_id           = local.namespace
  engine               = "redis"
  node_type            = "cache.t4g.micro"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.redis.name
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

# VIC 2.0 keeps login codes, sessions and rate limits in Redis: keys must not be evicted.
# The cluster is shared with NGO Hub, so this applies to its cache keys too.
resource "aws_elasticache_parameter_group" "redis" {
  name   = "${local.namespace}-redis6"
  family = "redis6.x"

  parameter {
    name  = "maxmemory-policy"
    value = "noeviction"
  }
}
