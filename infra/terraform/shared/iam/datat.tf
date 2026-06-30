# Getting the ARN for the ecr repo
data "aws_ecr_repository" "prod_ai_platform_knowledge_service" {
  name = "production-ai-platform/knowledge-service"
  
}