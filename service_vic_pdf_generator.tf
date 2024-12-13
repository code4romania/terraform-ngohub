data "archive_file" "pdf_generator" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/vic/pdf_generator"
  output_path = "${path.module}/lambda/vic/pdf_generator.zip"
}

resource "aws_s3_object" "pdf_generator" {
  bucket = module.vic_s3_private.bucket
  key    = "lambda/pdf_generator.zip"
  source = data.archive_file.pdf_generator.output_path
}

resource "aws_lambda_function" "pdf_generator" {
  function_name = "${local.namespace}-pdf_generator"
  role          = aws_iam_role.pdf_generator_lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  s3_bucket     = module.vic_s3_private.bucket
  s3_key        = aws_s3_object.pdf_generator.key
  memory_size   = 512
  timeout       = 30

  vpc_config {
    subnet_ids         = module.subnets.private_subnet_ids
    security_group_ids = [aws_security_group.pdf_generator_lambda.id]
  }

  environment {
    variables = {
      S3_BUCKET = module.vic_s3_private.bucket
    }
  }
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

resource "aws_iam_role_policy" "pdf_generator_lambda_role" {
  name   = "s3-access"
  role   = aws_iam_role.pdf_generator_lambda.id
  policy = data.aws_iam_policy_document.pdf_generator_lambda_s3.json
}

data "aws_iam_policy_document" "pdf_generator_lambda_s3" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:GetObjectAcl",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      module.vic_s3_private.arn,
      "${module.vic_s3_private.arn}/*",
    ]
  }
}

resource "aws_api_gateway_rest_api" "pdf_generator" {
  name        = "${local.namespace}-pdf-generator"
  description = "Generate a PDF from an HTML template"

  endpoint_configuration {
    types = ["PRIVATE"]
  }
}

resource "aws_api_gateway_resource" "generate_pdf" {
  rest_api_id = aws_api_gateway_rest_api.pdf_generator.id
  parent_id   = aws_api_gateway_rest_api.pdf_generator.root_resource_id
  path_part   = "generate-pdf"
}

resource "aws_api_gateway_method" "generate_pdf" {
  rest_api_id   = aws_api_gateway_rest_api.pdf_generator.id
  resource_id   = aws_api_gateway_resource.generate_pdf.id
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_security_group" "pdf_generator_lambda" {
  name        = "${local.namespace}-pdf_generator_lambda"
  description = "Security Group attached to the PDF generator lambda (${var.environment})"
  vpc_id      = module.vpc.vpc_id


  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
}
