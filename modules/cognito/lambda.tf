# amplify_login_create_auth_challenge
resource "aws_lambda_function" "amplify_login_create_auth_challenge" {
  count            = var.amplify_login_create_auth_challenge != null ? 1 : 0
  function_name    = "${var.namespace}-amplify_login_create_auth_challenge"
  filename         = var.amplify_login_create_auth_challenge.output_path
  role             = aws_iam_role.amplify_login_lambda.arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = var.amplify_login_create_auth_challenge.output_base64sha256
}

resource "aws_lambda_permission" "amplify_login_create_auth_challenge_permission" {
  count         = var.amplify_login_create_auth_challenge != null ? 1 : 0
  statement_id  = "createAuthChallenge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.amplify_login_create_auth_challenge[0].function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.this.arn
}

# amplify_login_define_auth_challenge
resource "aws_lambda_function" "amplify_login_define_auth_challenge" {
  count            = var.amplify_login_define_auth_challenge != null ? 1 : 0
  function_name    = "${var.namespace}-amplify_login_define_auth_challenge"
  filename         = var.amplify_login_define_auth_challenge.output_path
  role             = aws_iam_role.amplify_login_lambda.arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = var.amplify_login_define_auth_challenge.output_base64sha256
}

resource "aws_lambda_permission" "amplify_login_define_auth_challenge_permission" {
  count         = var.amplify_login_define_auth_challenge != null ? 1 : 0
  statement_id  = "defineAuthChallenge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.amplify_login_define_auth_challenge[0].function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.this.arn
}

# amplify_login_verify_auth_challenge_response
resource "aws_lambda_function" "amplify_login_verify_auth_challenge_response" {
  count            = var.amplify_login_verify_auth_challenge_response != null ? 1 : 0
  function_name    = "${var.namespace}-amplify_login_verify_auth_challenge_response"
  filename         = var.amplify_login_verify_auth_challenge_response.output_path
  role             = aws_iam_role.amplify_login_lambda.arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = var.amplify_login_verify_auth_challenge_response.output_base64sha256
}

resource "aws_lambda_permission" "amplify_login_verify_auth_challenge_response" {
  count         = var.amplify_login_verify_auth_challenge_response != null ? 1 : 0
  statement_id  = "verifyAuthChallenge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.amplify_login_verify_auth_challenge_response[0].function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.this.arn
}

# amplify_login_custom_message
resource "aws_lambda_function" "amplify_login_custom_message" {
  count            = var.amplify_login_custom_message != null ? 1 : 0
  function_name    = "${var.namespace}-amplify_login_custom_message"
  filename         = var.amplify_login_custom_message.output_path
  role             = aws_iam_role.amplify_login_lambda.arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = var.amplify_login_custom_message.output_base64sha256

  environment {
    variables = {
      onghub_frontend_url : var.frontend_domain
      email_contact : var.email_contact
      email_assets_url : var.email_assets_url
    }
  }
}

resource "aws_lambda_permission" "amplify_login_custom_message" {
  count         = var.amplify_login_custom_message != null ? 1 : 0
  statement_id  = "customMessageTrigger"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.amplify_login_custom_message[0].function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.this.arn
}

# login_pre_authentication_check
resource "aws_lambda_function" "login_pre_authentication_check" {
  count            = var.login_pre_authentication_check != null ? 1 : 0
  function_name    = "${var.namespace}-login_pre_authentication_check"
  filename         = var.login_pre_authentication_check.output_path
  role             = aws_iam_role.amplify_login_lambda.arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = var.login_pre_authentication_check.output_base64sha256

  environment {
    variables = {
      onghub_cognito_client_id : aws_cognito_user_pool_client.this.id
      onghub_api_url : var.backend_domain
      onghub_api_check_access_endpoint : "hasAccess",
      onghub_hmac_api_key : var.hmac_api_key
      onghub_hmac_secret_key : var.hmac_secret_key
    }
  }
}

resource "aws_lambda_permission" "login_pre_authentication_check_permission" {
  count         = var.login_pre_authentication_check != null ? 1 : 0
  statement_id  = "createAuthChallenge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.login_pre_authentication_check[0].function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.this.arn
}
