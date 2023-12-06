resource "aws_secretsmanager_secret" "this" {
  name = "${var.name}-user"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id

  secret_string = jsonencode({
    "access_key_id"     = aws_iam_access_key.this.id
    "secret_access_key" = aws_iam_access_key.this.secret
    "ses_smtp_password" = aws_iam_access_key.this.ses_smtp_password_v4
  })
}
