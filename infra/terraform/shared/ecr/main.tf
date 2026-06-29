# ECR repo
resource "aws_ecr_repository" "production-ai-platform-ecr-repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = var.ecr_image_tag_mutability

  encryption_configuration {
    encryption_type = var.ecr_encryption_type
  }

  image_scanning_configuration {
    scan_on_push = var.ecr_image_scan_on_push
  }

  tags = {
    Name = var.ecr_repo_tags["Name"]
    Environment = var.ecr_repo_tags["Environment"]
    Project = var.ecr_repo_tags["Project"]
  }
}

# aws ecr lifecycle policy to expire untagged images older than 30 days
resource "aws_ecr_lifecycle_policy" "example" {
  repository = aws_ecr_repository.production-ai-platform-ecr-repo.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images older than 30 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}