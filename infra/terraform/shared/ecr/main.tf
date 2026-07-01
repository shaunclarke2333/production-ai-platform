# Creating ECR repo from local module
module "production_ai_platform_ecr" {
  source = "../../modules/ecr" # Path to the ECR module

  ecr_repo_name            = var.ecr_repo_name
  ecr_image_tag_mutability = var.ecr_image_tag_mutability
  ecr_encryption_type      = var.ecr_encryption_type
  ecr_image_scan_on_push   = var.ecr_image_scan_on_push
  ecr_repo_tags            = var.ecr_repo_tags
}

# Returning the ECR repo URL as an output
output "repository_url" {
  value = module.production_ai_platform_ecr.repository_url
}
