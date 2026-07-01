# ECR repo local module
resource "aws_ecr_repository" "this" {
  name                 = var.ecr_repo_name
  image_tag_mutability = var.ecr_image_tag_mutability

  encryption_configuration {
    encryption_type = var.ecr_encryption_type
  }

  image_scanning_configuration {
    scan_on_push = var.ecr_image_scan_on_push
  }

  tags = var.ecr_repo_tags
}

# aws ecr lifecycle policy to expire untagged images older than 30 days
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    "rules" : [
      {
        rulePriority : 1,
        description : "Expire untagged images older than 30 days",
        selection : {
          tagStatus : "untagged",
          countType : "sinceImagePushed",
          countUnit : "days",
          countNumber : 30
        },
        action : { "type" : "expire" }
      },
      {
        rulePriority : 2,
        description : "Keep only the last 20 tagged images",
        selection : {
          tagStatus : "any",
          countType : "imageCountMoreThan",
          countNumber : 20
        },
        action : { type : "expire" }
      }
    ]
  })
}
