output "arn" {
  value = aws_cognito_user_pool.this.arn
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.this.id
}

output "user_pool_id" {
  value = aws_cognito_user_pool.this.id
}

output "oauth_domain" {
  value = aws_cognito_user_pool_domain.custom.domain
}
