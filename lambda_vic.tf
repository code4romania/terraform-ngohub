data "archive_file" "vic_amplify_login_create_auth_challenge" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/vic/amplify_login_create_auth_challenge"
  output_path = "${path.module}/lambda/vic/amplify_login_create_auth_challenge.zip"
}

data "archive_file" "vic_amplify_login_define_auth_challenge" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/vic/amplify_login_define_auth_challenge"
  output_path = "${path.module}/lambda/vic/amplify_login_define_auth_challenge.zip"
}

data "archive_file" "vic_amplify_login_verify_auth_challenge_response" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/vic/amplify_login_verify_auth_challenge_response"
  output_path = "${path.module}/lambda/vic/amplify_login_verify_auth_challenge_response.zip"
}

data "archive_file" "vic_amplify_login_custom_message" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/vic/amplify_login_custom_message"
  output_path = "${path.module}/lambda/vic/amplify_login_custom_message.zip"
}
