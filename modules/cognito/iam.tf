resource "aws_iam_role" "amplify_login_lambda" {
  name               = "${var.namespace}-amplify-login-lambda"
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
  name   = "${var.namespace}-lambda-logging"
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
  name   = "${var.namespace}-amplify-backend"
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

