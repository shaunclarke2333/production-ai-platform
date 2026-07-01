# Outputting the ci_deploy role ARN
output "ci_deploy_role_arn" {
  description = "The ARN of the role for github actions to assume"
  value       = aws_iam_role.ci_deploy.arn
}
