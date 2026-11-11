data "archive_file" "ngohub_amplify_login_create_auth_challenge" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/ngohub/amplify_login_create_auth_challenge"
  output_path = "${path.module}/lambda/ngohub/amplify_login_create_auth_challenge.zip"
}

data "archive_file" "ngohub_amplify_login_define_auth_challenge" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/ngohub/amplify_login_define_auth_challenge"
  output_path = "${path.module}/lambda/ngohub/amplify_login_define_auth_challenge.zip"
}

data "archive_file" "ngohub_amplify_login_verify_auth_challenge_response" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/ngohub/amplify_login_verify_auth_challenge_response"
  output_path = "${path.module}/lambda/ngohub/amplify_login_verify_auth_challenge_response.zip"
}

data "archive_file" "ngohub_amplify_login_custom_message" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/ngohub/amplify_login_custom_message"
  output_path = "${path.module}/lambda/ngohub/amplify_login_custom_message.zip"
}

data "archive_file" "ngohub_login_pre_authentication_check" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/ngohub/login_pre_authentication_check"
  output_path = "${path.module}/lambda/ngohub/login_pre_authentication_check.zip"
}
