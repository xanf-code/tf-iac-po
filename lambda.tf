resource "aws_lambda_function" "po_api_lambda" {
  function_name = "${var.all_vars_prefix}-api-lambda"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.po_lambda_role.arn
  handler       = "index.handler"
  filename      = "./lambda/index.zip"
  timeout       = 30
  depends_on = [
    aws_iam_role_policy_attachment.po_lambda_logs_attachment,
    aws_cloudwatch_log_group.po_log_group,
  ]
}

resource "aws_cloudwatch_log_group" "po_log_group" {
  name              = "/aws/lambda/${var.all_vars_prefix}-api-lambda"
  retention_in_days = 7
}