resource "aws_api_gateway_rest_api" "po-gateway-rest-api" {
  name = "${var.all_vars_prefix}-po-gateway"
}

resource "aws_api_gateway_resource" "po-gateway-rest-resource" {
  rest_api_id = aws_api_gateway_rest_api.po-gateway-rest-api.id
  parent_id   = aws_api_gateway_rest_api.po-gateway-rest-api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "get_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.po-gateway-rest-api.id
  resource_id   = aws_api_gateway_resource.po-gateway-rest-resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.po-gateway-rest-api.id
  resource_id             = aws_api_gateway_resource.po-gateway-rest-resource.id
  http_method             = aws_api_gateway_method.get_api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.po_api_lambda.invoke_arn
}

resource "aws_lambda_permission" "apigw_po_api_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.po_api_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.account_id}:${aws_api_gateway_rest_api.po-gateway-rest-api.id}/*/${aws_api_gateway_method.get_api_method.http_method}${aws_api_gateway_resource.po-gateway-rest-resource.path}"
}

resource "aws_api_gateway_deployment" "po_api_lambda_deployment" {
  rest_api_id = aws_api_gateway_rest_api.po-gateway-rest-api.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.po-gateway-rest-api.body))
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_api_gateway_method.get_api_method, aws_api_gateway_integration.get_api_integration]
}

resource "aws_api_gateway_stage" "po_api_lambda_deployment_dev_stage" {
  deployment_id = aws_api_gateway_deployment.po_api_lambda_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.po-gateway-rest-api.id
  stage_name    = "api"
}