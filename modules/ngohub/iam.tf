resource "aws_iam_user" "iam_user" {
  name = "${local.namespace}-user"
}

resource "aws_iam_access_key" "iam_user_key" {
  user = aws_iam_user.iam_user.name
}


resource "aws_iam_role" "amplify_login_lambda" {
  name               = "${local.namespace}-amplify-login-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_role_policy.json
}

data "aws_iam_policy_document" "lambda_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name   = "${local.namespace}-lambda-logging"
  policy = data.aws_iam_policy_document.lambda_logging_policy.json
}

data "aws_iam_policy_document" "lambda_logging_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"]
  }
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.amplify_login_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_policy" "amplify_backend" {
  name   = "${local.namespace}-amplify-backend"
  policy = data.aws_iam_policy_document.amplify_login_lambda_policy.json
}

data "aws_iam_policy_document" "amplify_login_lambda_policy" {
  statement {
    actions = [
      "amplifybackend:GetToken",
      "amplifybackend:DeleteToken"
    ]

    resources = ["arn:aws:amplifybackend:*:*:/backend/*"]
  }

  statement {
    actions   = ["amplify:GetApp"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "attach_amplify_login_lambda_policy_to_lambda_role" {
  role       = aws_iam_role.amplify_login_lambda.name
  policy_arn = aws_iam_policy.amplify_backend.arn
}

# resource "aws_iam_user_policy" "files_access_policy" {
#   name   = "s3-files-access-policy"
#   user   = aws_iam_user.iam_user.name
#   policy = data.aws_iam_policy_document.bucket_acccess.json
# }

resource "aws_iam_user_policy_attachment" "cognito_power_user_policy_attachment" {
  user       = aws_iam_user.iam_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoPowerUser"
}

# resource "aws_ses_identity_policy" "email_send_policy" {
#   identity = data.aws_ses_domain_identity.main.arn
#   name     = "email-send-policy"
#   policy   = data.aws_iam_policy_document.ses_email_send.json
# }
