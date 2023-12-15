module "ngohub_cognito" {
  source = "./modules/cognito"

  namespace   = local.ngohub.namespace
  environment = var.environment
  region      = var.region

  root_domain  = var.root_domain
  email_domain = local.mail_domain

  certificate_arn = aws_acm_certificate.global.arn

  auth_domain     = local.ngohub.auth.domain
  backend_domain  = local.ngohub.backend.domain
  frontend_domain = local.ngohub.frontend.domain

  ui_css  = file("${path.module}/assets/cognito/custom.css")
  ui_logo = filebase64("${path.module}/assets/cognito/ngohub.png")

  hmac_api_key    = var.ngohub_hmac_api_key
  hmac_secret_key = var.ngohub_hmac_secret_key

  # Settings this to false enables user felf-service sign-up in Cognito
  # We don't want this for ngohub, but we do for vic
  allow_admin_create_user_only = true

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  enable_localhost_urls = var.environment != "production"
  ses_identiy_arn       = aws_sesv2_email_identity.main.arn

  enable_sms      = true
  sms_external_id = local.isProduction ? "NGOHub" : "NGOHub-test"

  email_contact    = var.email_contact
  email_from       = local.mail_from
  email_assets_url = "https://${module.s3_public.bucket_regional_domain_name}"
}

module "ngohub_frontend" {
  source = "./modules/amplify"

  name        = "ngohub"
  repository  = "https://github.com/code4romania/onghub"
  branch      = "develop"
  environment = var.environment

  frontend_domain = local.ngohub.frontend.domain

  github_access_token = var.github_access_token

  environment_variables = {
    AMPLIFY_MONOREPO_APP_ROOT      = "frontend"
    REACT_APP_API_URL              = "https://${local.ngohub.backend.domain}"
    REACT_APP_AWS_REGION           = var.region
    REACT_APP_COGNITO_OAUTH_DOMAIN = module.ngohub_cognito.oauth_domain
    REACT_APP_FRONTEND_URL         = "https://${local.ngohub.frontend.domain}"
    REACT_APP_USER_POOL_CLIENT_ID  = module.ngohub_cognito.user_pool_client_id
    REACT_APP_USER_POOL_ID         = module.ngohub_cognito.user_pool_id
    REACT_APP_PUBLIC_ASSETS_URL    = module.s3_public.bucket_regional_domain_name
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

module "ngohub_backend" {
  source = "./modules/ecs-service"

  depends_on = [module.ecs_cluster]

  name         = local.ngohub.namespace
  cluster_name = module.ecs_cluster.cluster_name
  min_capacity = 1
  max_capacity = 3

  image_repo = local.ngohub.backend.image.repo
  image_tag  = local.ngohub.backend.image.tag

  use_load_balancer       = true
  lb_dns_name             = aws_lb.main.dns_name
  lb_zone_id              = aws_lb.main.zone_id
  lb_vpc_id               = module.vpc.vpc_id
  lb_listener_arn         = aws_lb_listener.https.arn
  lb_hosts                = [local.ngohub.backend.domain]
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
      name  = "LOGGING_LEVEL"
      value = var.environment == "production" ? "warn" : "debug"
    },
    {
      name  = "DATABASE_NAME"
      value = "ngohub"
    },
    {
      name  = "COGNITO_CLIENT_ID"
      value = module.ngohub_cognito.user_pool_client_id
    },
    {
      name  = "COGNITO_USER_POOL_ID"
      value = module.ngohub_cognito.user_pool_id
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
      name  = "MAIL_FROM"
      value = local.mail_from
    },
    {
      name  = "MAIL_CONTACT"
      value = var.email_contact
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
      value = module.ngohub_s3_private.bucket
    },
    {
      name  = "AWS_S3_BUCKET_NAME_PUBLIC"
      value = module.s3_public.bucket_regional_domain_name
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
      valueFrom = "${module.ngohub_iam_user.secret_arn}:access_key_id::"
    },
    {
      name      = "AWS_SECRET_ACCESS_KEY"
      valueFrom = "${module.ngohub_iam_user.secret_arn}:secret_access_key::"
    },
    {
      name      = "MAIL_USER"
      valueFrom = "${module.ngohub_iam_user.secret_arn}:access_key_id::"
    },
    {
      name      = "MAIL_PASS"
      valueFrom = "${module.ngohub_iam_user.secret_arn}:ses_smtp_password::"
    },
  ]

  allowed_secrets = [
    aws_secretsmanager_secret.encryption_key.arn,
    aws_secretsmanager_secret.rds.arn,
    module.ngohub_iam_user.secret_arn,
  ]
}

resource "aws_secretsmanager_secret" "encryption_key" {
  name = "${local.ngohub.namespace}-encryption_key-${random_string.secrets_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "encryption_key" {
  secret_id     = aws_secretsmanager_secret.encryption_key.id
  secret_string = var.ngohub_hmac_encryption_key
}


module "ngohub_iam_user" {
  source = "./modules/iam_user"

  name   = "${local.ngohub.namespace}-user"
  policy = data.aws_iam_policy_document.ngohub_iam_user_policy.json
}


data "aws_iam_policy_document" "ngohub_iam_user_policy" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:GetObjectAcl",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      module.ngohub_s3_private.arn,
      "${module.ngohub_s3_private.arn}/*",
      module.s3_public.arn,
      "${module.s3_public.arn}/*",
    ]
  }

  statement {
    actions = [
      "SES:SendEmail",
      "SES:SendRawEmail",
    ]

    resources = [
      aws_sesv2_email_identity.main.arn,
      aws_sesv2_configuration_set.main.arn,
    ]
  }

  statement {
    actions = [
      "cognito-idp:AdminCreateUser",
      "cognito-idp:AdminDeleteUser",
      "cognito-idp:AdminUpdateUserAttributes",
      "cognito-idp:AdminUserGlobalSignOut",
    ]

    resources = [
      module.ngohub_cognito.arn
    ]
  }
}


module "ngohub_s3_private" {
  source = "./modules/s3"

  name = "${local.ngohub.namespace}-private"

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
  policy                  = data.aws_iam_policy_document.ngohub_s3_private_policy.json
}

data "aws_iam_policy_document" "ngohub_s3_private_policy" {
  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${module.ngohub_s3_private.arn}/*/logo/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

module "s3_public" {
  source = "./modules/s3"

  name = "${local.ngohub.namespace}-public"

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  policy                  = data.aws_iam_policy_document.ngohub_s3_public_policy.json
}

data "aws_iam_policy_document" "ngohub_s3_public_policy" {
  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${module.s3_public.arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_object" "ngohub_email_assets" {
  for_each = fileset("${path.module}/assets/email", "**")

  bucket = module.s3_public.bucket
  key    = "email/${each.value}"
  source = "${path.module}/assets/email/${each.value}"
  etag   = filemd5("${path.module}/assets/email/${each.value}")

  override_provider {
    default_tags {
      tags = {}
    }
  }
}

resource "aws_s3_object" "ngohub_public_assets" {
  for_each = fileset("${path.module}/assets/file_templates", "**")

  bucket = module.s3_public.bucket
  key    = "file_templates/${each.value}"
  source = "${path.module}/assets/file_templates/${each.value}"
  etag   = filemd5("${path.module}/assets/file_templates/${each.value}")

  override_provider {
    default_tags {
      tags = {}
    }
  }
}
