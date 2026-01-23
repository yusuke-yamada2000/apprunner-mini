# ECR repository
resource "aws_ecr_repository" "app" {
  name = "apprunner-mini"
}

# App Runner service (既存を import する)
resource "aws_apprunner_service" "app" {
  service_name = "apprunner-mini"

  observability_configuration {
    observability_enabled = false
  }

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access.arn
    }

    auto_deployments_enabled = true

    image_repository {
      image_repository_type = "ECR"
      image_identifier      = "072365629145.dkr.ecr.ap-northeast-1.amazonaws.com/apprunner-mini:latest"

      image_configuration {
        port = "3000"
      }
    }
  }

  health_check_configuration {
    protocol            = "HTTP"
    path                = "/health"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 1
    unhealthy_threshold = 5
  }
}
