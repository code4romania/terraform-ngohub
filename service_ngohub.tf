module "ngohub" {
  source = "./modules/ngohub"

  environment = var.environment
  region      = var.region

  root_domain  = var.root_domain
  email_domain = local.mail.domain

  github_access_token = var.github_access_token

  certificate_arn = aws_acm_certificate.global.arn

  auth_domain     = local.ngohub.auth.domain
  backend_domain  = local.ngohub.backend.domain
  frontend_domain = local.ngohub.frontend.domain

  hmac_api_key    = var.ngohub_hmac_api_key
  hmac_secret_key = var.ngohub_hmac_secret_key
}

module "ecs_service" {
  source = "./modules/ecs-service"

  name         = module.ngohub.namespace
  cluster_name = module.ecs_cluster.cluster_name
  min_capacity = 1
  max_capacity = 3

  image_repo = data.aws_ecr_repository.ngohub_backend.repository_url
  image_tag  = var.ngohub_backend_tag

  use_load_balancer       = true
  lb_dns_name             = aws_lb.main.dns_name
  lb_zone_id              = aws_lb.main.zone_id
  lb_vpc_id               = module.vpc.vpc_id
  lb_listener_arn         = aws_lb_listener.https.arn
  lb_hosts                = [local.ngohub.backend.domain]
  lb_health_check_enabled = true
  lb_path                 = "/health"

  container_memory_soft_limit = 512
  container_memory_hard_limit = 1024

  log_group_name                 = module.ecs_cluster.log_group_name
  service_discovery_namespace_id = module.ecs_cluster.service_discovery_namespace_id

  container_port          = 80
  network_mode            = "awsvpc"
  network_security_groups = [aws_security_group.ecs.id]
  network_subnets         = [module.subnets.private_subnet_ids[1]]

  predefined_metric_type = "ECSServiceAverageCPUUtilization"
  target_value           = 80

  ordered_placement_strategy = [
    {
      field = "attribute:ecs.availability-zone"
      type  = "spread"
    },
    {
      field = "instanceId"
      type  = "spread"
    },
    {
      type  = "binpack"
      field = "memory"
    }
  ]

  environment = [
    {
      name  = "ONGHUB_URL"
      value = "https://${local.ngohub.frontend.domain}"
    },
    {
      name  = "NODE_ENV"
      value = var.environment
    },
    {
      name  = "PORT"
      value = 80
    },
    {
      name  = "DATABASE_NAME"
      value = "ngohub"
    },
    {
      name  = "COGNITO_CLIENT_ID"
      value = module.ngohub.cognito_client_id
    },
    {
      name  = "COGNITO_USER_POOL_ID"
      value = module.ngohub.cognito_user_pool_id
    },
    {
      name  = "COGNITO_REGION"
      value = var.region
    },
    {
      name  = "MAIL_HOST"
      value = "email-smtp.${var.region}.amazonaws.com"
    },
    {
      name  = "MAIL_PORT"
      value = 587
    },
    {
      name  = "REDIS_HOST"
      value = aws_elasticache_cluster.redis.cache_nodes.0.address
    },
    {
      name  = "REDIS_PORT"
      value = aws_elasticache_cluster.redis.port
    },
    {
      name  = "THROTTLE_LIMIT"
      value = 600
    },
    {
      name  = "THROTTLE_TTL"
      value = 60
    },
    {
      name  = "CACHE_TTL"
      value = 600
    },
  ]

  secrets = [
    {
      name      = "ENCRYPTION_KEY"
      valueFrom = aws_secretsmanager_secret.encryption_key.arn
    },
    {
      name      = "DATABASE_HOST"
      valueFrom = "${aws_secretsmanager_secret.rds.arn}:host::"
    },
    {
      name      = "DATABASE_PORT"
      valueFrom = "${aws_secretsmanager_secret.rds.arn}:port::"
    },
    {
      name      = "DATABASE_USER"
      valueFrom = "${aws_secretsmanager_secret.rds.arn}:username::"
    },
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = "${aws_secretsmanager_secret.rds.arn}:password::"
    },
  ]

  allowed_secrets = [
    aws_secretsmanager_secret.encryption_key.arn,
    aws_secretsmanager_secret.rds.arn
  ]
}

resource "aws_secretsmanager_secret" "encryption_key" {
  name = "${module.ngohub.namespace}-encryption_key-${random_string.secrets_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "encryption_key" {
  secret_id     = aws_secretsmanager_secret.encryption_key.id
  secret_string = var.ngohub_hmac_encryption_key
}
