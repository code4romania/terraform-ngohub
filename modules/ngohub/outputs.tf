output "cognito_client_id" {
  value = aws_cognito_user_pool_client.this.id
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.this.id
}

output "namespace" {
  value = local.namespace
}
