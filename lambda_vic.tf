# Zips are committed and rebuilt with `python3 lambda/build.py` (see lambda/build.py).
locals {
  vic_lambdas = {
    for name in [
      "amplify_login_create_auth_challenge",
      "amplify_login_define_auth_challenge",
      "amplify_login_verify_auth_challenge_response",
      "amplify_login_custom_message",
      ] : name => {
      output_path         = "${path.module}/lambda/vic/${name}.zip"
      output_base64sha256 = filebase64sha256("${path.module}/lambda/vic/${name}.zip")
    }
  }
}
