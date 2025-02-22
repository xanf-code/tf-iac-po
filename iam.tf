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