terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# --- 1. API Gateway (HTTP API) ---
resource "aws_apigatewayv2_api" "strangler_gw" {
  name          = "strangler-fig-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.strangler_gw.id
  name        = "$default"
  auto_deploy = true
}

# --- 2. Modern Target: AWS Lambda Function ---
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"
  source_content = <<EOF
exports.handler = async (event) => {
    return {
        statusCode: 200,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ message: "Hello from the Modern Serverless Lambda backend!" }),
    };
};
EOF
  source_content_filename = "index.js"
}

resource "aws_iam_role" "lambda_exec" {
  name = "strangler_lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_lambda_function" "modern_service" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "modern-migration-service"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

# --- 3. API Gateway Integrations & Routes ---
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.strangler_gw.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.modern_service.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "modern_route" {
  api_id    = aws_apigatewayv2_api.strangler_gw.id
  route_key = "GET /api/v1/resource"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.modern_service.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.strangler_gw.execution_arn}/*/*"
}

output "api_endpoint" {
  description = "The HTTP API Gateway endpoint for testing the Strangler Fig routing"
  value       = aws_apigatewayv2_api.strangler_gw.api_endpoint
}