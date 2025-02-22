resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  role       = aws_iam_role.po_codebuild_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

resource "aws_codebuild_project" "next_js_portfolio_codebuild_project" {
  name          = "${var.all_vars_prefix}-codebuild-project"
  description   = "Builds portfolio from GitHub using buildspec file stored in repo"
  service_role  = aws_iam_role.po_codebuild_service_role.arn
  build_timeout = 30

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "API_URI"
      value = "https://${aws_api_gateway_rest_api.po-gateway-rest-api.id}.execute-api.us-east-1.amazonaws.com/${aws_api_gateway_stage.po_api_lambda_deployment_dev_stage.stage_name}"
    }
    environment_variable {
      name  = "DOCKERHUB_USERNAME"
      value = var.docker_username
    }
    environment_variable {
      name  = "DOCKERHUB_PASSWORD"
      value = var.docker_password
    }
    privileged_mode = true
  }

  source {
    type            = "GITHUB"
    location        = var.git_repo_link
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  # add vpc configs later on
}