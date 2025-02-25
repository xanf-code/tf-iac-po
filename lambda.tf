resource "aws_lambda_function" "po_api_lambda" {
  function_name = "${var.all_vars_prefix}-api-lambda"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.po_lambda_role.arn
  handler       = "index.handler"
  filename      = "./lambda/index.zip"
  timeout       = 30

  environment {
    variables = {
      SQS_QUEUE_URL = aws_sqs_queue.po_sqs_queue.url
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.po_lambda_logs_attachment,
    aws_cloudwatch_log_group.po_log_group,
  ]
}
resource "aws_cloudwatch_log_group" "po_log_group" {
  name              = "/aws/lambda/${var.all_vars_prefix}-api-lambda"
  retention_in_days = 7
}

# IP lambda starts here
resource "aws_lambda_function" "po_ip_lambda" {
  function_name = "${var.all_vars_prefix}-ip-lambda"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.po_ip_lambda_role.arn
  handler       = "index.handler"
  filename      = "./ip_lambda/index.zip"
  timeout       = 30

  depends_on = [
    aws_iam_role_policy_attachment.po_lambda_logs_attachment,
    aws_cloudwatch_log_group.po_ip_log_group,
  ]
}

resource "aws_cloudwatch_log_group" "po_ip_log_group" {
  name              = "/aws/lambda/${var.all_vars_prefix}-ip-lambda"
  retention_in_days = 7
}

resource "aws_lambda_event_source_mapping" "po_ip_lambda_trigger" {
  event_source_arn = aws_sqs_queue.po_sqs_queue.arn
  function_name    = aws_lambda_function.po_ip_lambda.arn
  batch_size       = 10
  enabled          = true
}