resource "aws_db_instance" "main" {
  identifier          = local.namespace
  db_name             = "ngohub"
  instance_class      = local.db.instance_class
  multi_az            = false
  publicly_accessible = false
  deletion_protection = local.isProduction

  availability_zone = local.availability_zone

  username = "postgres"
  password = random_password.database.result

  iam_database_authentication_enabled = true

  engine                      = "postgres"
  engine_version              = "13.13"
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true

  # storage
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  # backup
  backup_retention_period = 30
  backup_window           = "04:00-04:30"
  copy_tags_to_snapshot   = true
  skip_final_snapshot     = var.environment != "production"

  maintenance_window = "Tue:04:45-Tue:06:00"

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database.id]
}

resource "aws_security_group" "database" {
  name        = "${local.namespace}-rds"
  description = "Inbound - Security Group attached to the RDS instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = "5432"
    to_port     = "5432"
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${local.namespace}-db-private"
  subnet_ids = module.subnets.private_subnet_ids
}

resource "random_password" "database" {
  length  = 32
  special = false

  lifecycle {
    ignore_changes = [
      length,
      special
    ]
  }
}

resource "aws_secretsmanager_secret" "rds" {
  name = "${local.namespace}-db_credentials-${random_string.secrets_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id

  secret_string = jsonencode({
    "engine"   = aws_db_instance.main.engine
    "username" = aws_db_instance.main.username
    "password" = aws_db_instance.main.password
    "host"     = aws_db_instance.main.address
    "port"     = aws_db_instance.main.port
  })
}
