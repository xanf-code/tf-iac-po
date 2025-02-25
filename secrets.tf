resource "aws_secretsmanager_secret" "po_gateway_resource_id_secret" {
  name                    = "${var.all_vars_prefix}-secrets-api-url-external-v1"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "po_gateway_resource_id_secret_version" {
  secret_id = aws_secretsmanager_secret.po_gateway_resource_id_secret.id
  secret_string = jsonencode({
    invoke_url = format(
      "https://%s.execute-api.%s.amazonaws.com/%s",
      tostring(aws_api_gateway_rest_api.po-gateway-rest-api.id),
      var.aws_region,
      tostring(aws_api_gateway_stage.po_api_lambda_deployment_dev_stage.stage_name)
    )
  })
}