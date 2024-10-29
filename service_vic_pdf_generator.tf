data "archive_file" "pdf_generator" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/vic/pdf_generator"
  output_path = "${path.module}/lambda/vic/pdf_generator.zip"
}

resource "aws_lambda_function" "pdf_generator" {
  function_name    = "${local.namespace}-pdf_generator"
  filename         = data.archive_file.pdf_generator.output_path
  role             = aws_iam_role.pdf_generator_lambda.arn
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.pdf_generator.output_base64sha256
}

resource "aws_iam_role" "pdf_generator_lambda" {
  name               = "${local.namespace}-pdf-generator-lambda"
  assume_role_policy = data.aws_iam_policy_document.pdf_generator_lambda_role.json
}

data "aws_iam_policy_document" "pdf_generator_lambda_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
