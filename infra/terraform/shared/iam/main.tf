# IAM OIDC resource that gives GitHub Actions the ability to assume roles in AWS so the CICD pipeline can deploy to AWS.
resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # The thumbprint is no longer required and can also be left blank
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  tags = {
    "Environment" = "Shared"
    "Project"     = "Production AI Platform"
    "Name"        = "production-ai-platform-github-actions"
  }
}

# Policy that will be attached to the ci_deploy role to allow GHA to assume roles in AWS.
resource "aws_iam_policy" "ci_ecr_push" {
  name = "production-ai-platform-ci-ecr-push"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = data.aws_ecr_repository.prod_ai_platform_knowledge_service.arn
      },
    ]
  })

  tags = {
    "Environment" = "Shared"
    "Project"     = "Production AI Platform"
    "Name"        = "production-ai-platform-ci-ecr-push"
  }

}

# Role that will be assumed by GHA to allow it to make changes in AWS.
resource "aws_iam_role" "ci_deploy" {
  name = "production-ai-platform-ci-deploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:shaunclarke2333/production-ai-platform:ref:refs/heads/main"
          }

          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    "Environment" = "Shared"
    "Project"     = "Production AI Platform"
    "Name"        = "production-ai-platform-ci-deploy"
  }
}

# Attaching the policy to the role
resource "aws_iam_role_policy_attachment" "ci_deploy" {
  role       = aws_iam_role.ci_deploy.name
  policy_arn = aws_iam_policy.ci_ecr_push.arn
}
