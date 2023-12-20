resource "aws_cloudwatch_log_group" "amplify_login_create_auth_challenge" {
  count             = var.amplify_login_create_auth_challenge != null ? 1 : 0
  name              = "/aws/lambda/${aws_lambda_function.amplify_login_create_auth_challenge[0].function_name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "amplify_login_define_auth_challenge" {
  count             = var.amplify_login_define_auth_challenge != null ? 1 : 0
  name              = "/aws/lambda/${aws_lambda_function.amplify_login_define_auth_challenge[0].function_name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "amplify_login_verify_auth_challenge_response" {
  count             = var.amplify_login_verify_auth_challenge_response != null ? 1 : 0
  name              = "/aws/lambda/${aws_lambda_function.amplify_login_verify_auth_challenge_response[0].function_name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "amplify_login_custom_message" {
  count             = var.amplify_login_custom_message != null ? 1 : 0
  name              = "/aws/lambda/${aws_lambda_function.amplify_login_custom_message[0].function_name}"
  retention_in_days = 30
}
