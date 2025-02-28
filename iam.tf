resource "aws_iam_role" "po_lambda_role" {
  name               = "${var.all_vars_prefix}-lambda"
  assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "lambda.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid": ""
            }
        ]
    }
    EOF
}

resource "aws_iam_role" "po_ip_lambda_role" {
  name               = "${var.all_vars_prefix}-ip-lambda"
  assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "lambda.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid": ""
            }
        ]
    }
    EOF
}

resource "aws_iam_policy" "iam_logging_policy_for_po_lambda" {

  name        = "aws_iam_policy_for_po_api_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "po_lambda_logs_attachment" {
  role       = aws_iam_role.po_lambda_role.name
  policy_arn = aws_iam_policy.iam_logging_policy_for_po_lambda.arn
}

resource "aws_iam_role_policy_attachment" "po_ip_lambda_logs_attachment" {
  role       = aws_iam_role.po_ip_lambda_role.name
  policy_arn = aws_iam_policy.iam_logging_policy_for_po_lambda.arn
}

resource "aws_iam_role" "po_codebuild_service_role" {
  name = "${var.all_vars_prefix}-codebuild-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "iam_logging_policy_for_po_code_build" {

  name        = "aws_iam_policy_for_po_code_build_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws code build role"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "po_code_build_logs_attachment" {
  role       = aws_iam_role.po_codebuild_service_role.name
  policy_arn = aws_iam_policy.iam_logging_policy_for_po_code_build.arn
}

resource "aws_iam_role" "po_codepipeline_role" {
  name = "${var.all_vars_prefix}-codepipeline-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "codepipeline.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "po_codepipeline_policy" {
  role       = aws_iam_role.po_codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

resource "aws_iam_role_policy_attachment" "po_lambda_sqs_attachment" {
  role       = aws_iam_role.po_ip_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "api_lambda_sqs_attachment" {
  role       = aws_iam_role.po_ip_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy" "po_ip_lambda_sqs_send_policy" {
  name = "${var.all_vars_prefix}-ip-lambda-sqs-all-policy"
  role = aws_iam_role.po_ip_lambda_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage"]
        Effect   = "Allow"
        Resource = aws_sqs_queue.po_sqs_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "api_lambda_secrets_policy" {
  name = "${var.all_vars_prefix}-api_lambda_secrets_policy"
  role = aws_iam_role.po_lambda_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["secretsmanager:GetSecretValue"]
        Effect   = "Allow"
        Resource = aws_secretsmanager_secret.po_mongo_db_connection_string_id_secret.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "po_ip_lambda_secrets_policy" {
  name = "${var.all_vars_prefix}-ip_lambda_secrets_policy"
  role = aws_iam_role.po_ip_lambda_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["secretsmanager:GetSecretValue"]
        Effect   = "Allow"
        Resource = aws_secretsmanager_secret.po_mongo_db_connection_string_id_secret.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "po_lambda_sqs_send_policy" {
  name = "${var.all_vars_prefix}-api-lambda-sqs-send-policy"
  role = aws_iam_role.po_lambda_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sqs:SendMessage"]
        Effect   = "Allow"
        Resource = aws_sqs_queue.po_sqs_queue.arn
      }
    ]
  })
}