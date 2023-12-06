module "vic_cognito" {
  source = "./modules/cognito"

  namespace   = local.vic.namespace
  environment = var.environment
  region      = var.region

  root_domain  = var.root_domain
  email_domain = local.mail.domain

  certificate_arn = aws_acm_certificate.global.arn

  auth_domain     = local.vic.auth.domain
  backend_domain  = local.vic.backend.domain
  frontend_domain = local.vic.frontend.domain

  hmac_api_key    = var.ngohub_hmac_api_key
  hmac_secret_key = var.ngohub_hmac_secret_key

  allow_admin_create_user_only = false
  username_attributes          = ["email", "phone_number"]
  auto_verified_attributes     = ["email"]
}

module "vic_frontend" {
  source = "./modules/amplify"

  name        = "vic"
  repository  = "https://github.com/code4romania/vic"
  branch      = "develop"
  environment = var.environment

  frontend_domain = local.vic.frontend.domain

  github_access_token = var.github_access_token

  environment_variables = {
    AMPLIFY_MONOREPO_APP_ROOT      = "frontend"
    REACT_APP_API_URL              = "https://${local.vic.backend.domain}"
    REACT_APP_AWS_REGION           = var.region
    REACT_APP_COGNITO_OAUTH_DOMAIN = module.vic_cognito.oauth_domain
    REACT_APP_FRONTEND_URL         = "https://${local.vic.frontend.domain}"
    REACT_APP_USER_POOL_CLIENT_ID  = module.vic_cognito.user_pool_client_id
    REACT_APP_USER_POOL_ID         = module.vic_cognito.user_pool_id
  }

  build_spec = <<-EOT
    version: 1
    appRoot: frontend
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT
}

module "vic_backend" {
  source = "./modules/ecs-service"

  name         = local.vic.namespace
  cluster_name = module.ecs_cluster.cluster_name
  min_capacity = 1
  max_capacity = 3

  image_repo = data.aws_ecr_repository.vic_backend.repository_url
  image_tag  = var.vic_backend_tag

  use_load_balancer       = true
  lb_dns_name             = aws_lb.main.dns_name
  lb_zone_id              = aws_lb.main.zone_id
  lb_vpc_id               = module.vpc.vpc_id
  lb_listener_arn         = aws_lb_listener.https.arn
  lb_hosts                = [local.vic.backend.domain]
  lb_domain_zone_id       = data.aws_route53_zone.main.zone_id
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
      value = "https://${local.vic.frontend.domain}"
    },
    {
      name  = "ONG_HUB_API"
      value = "https://${local.ngohub.backend.domain}"
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
      value = "vic"
    },
    {
      name  = "COGNITO_CLIENT_ID_MOBILE"
      value = module.vic_cognito.user_pool_client_id
    },
    {
      name  = "COGNITO_USER_POOL_ID_MOBILE"
      value = module.vic_cognito.user_pool_id
    },
    {
      name  = "COGNITO_REGION_MOBILE"
      value = var.region
    },
    {
      name  = "COGNITO_CLIENT_ID_WEB"
      value = module.ngohub_cognito.user_pool_client_id
    },
    {
      name  = "COGNITO_USER_POOL_ID_WEB"
      value = module.ngohub_cognito.user_pool_id
    },
    {
      name  = "COGNITO_REGION_WEB"
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
      name  = "MAIL_FROM"
      value = "no-reply@${local.mail.domain}"
    },
    {
      name  = "MAIL_CONTACT"
      value = "infrastructure@onghub.ro"
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
    {
      name  = "AWS_S3_BUCKET_NAME"
      value = module.vic_s3_private.bucket
    },
    {
      name  = "AWS_S3_BUCKET_NAME_PUBLIC"
      value = module.vic_s3_public.bucket
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
    {
      name      = "AWS_ACCESS_KEY_ID"
      valueFrom = "${module.vic_iam_user.secret_arn}:access_key_id::"
    },
    {
      name      = "AWS_SECRET_ACCESS_KEY"
      valueFrom = "${module.vic_iam_user.secret_arn}:secret_access_key::"
    },
    {
      name      = "MAIL_USER"
      valueFrom = "${module.vic_iam_user.secret_arn}:access_key_id::"
    },
    {
      name      = "MAIL_PASS"
      valueFrom = "${module.vic_iam_user.secret_arn}:ses_smtp_password::"
    },
    {
      name      = "EXPO_PUSH_NOTIFICATIONS_ACCESS_TOKEN"
      valueFrom = aws_secretsmanager_secret.expo_push_notifications_access_token.arn
    },
  ]

  allowed_secrets = [
    aws_secretsmanager_secret.expo_push_notifications_access_token.arn,
    aws_secretsmanager_secret.encryption_key.arn,
    aws_secretsmanager_secret.rds.arn,
    module.vic_iam_user.secret_arn,
  ]
}

resource "aws_secretsmanager_secret" "expo_push_notifications_access_token" {
  name = "${local.ngohub.namespace}-expo_push_notifications_access_token-${random_string.secrets_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "expo_push_notifications_access_token" {
  secret_id     = aws_secretsmanager_secret.expo_push_notifications_access_token.id
  secret_string = var.expo_push_notifications_access_token
}


module "vic_iam_user" {
  source = "./modules/iam_user"

  name   = "${local.ngohub.namespace}-user"
  policy = data.aws_iam_policy_document.vic_iam_user_policy.json
}

data "aws_iam_policy_document" "vic_iam_user_policy" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:GetObjectAcl",
      "s3:PutObjectAcl",
      "s3:PutObject"
    ]

    resources = [
      module.vic_s3_private.arn,
      "${module.vic_s3_private.arn}/*",
      module.vic_s3_public.arn,
      "${module.vic_s3_public.arn}/*",
    ]
  }

  statement {
    actions = [
      "SES:SendEmail",
      "SES:SendRawEmail"
    ]

    resources = [
      aws_sesv2_email_identity.main.arn
    ]
  }
}


module "vic_s3_private" {
  source = "./modules/s3"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  name = "${local.namespace}-private"
}

module "vic_s3_public" {
  source = "./modules/s3"

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  name = "${local.namespace}-public"
}
