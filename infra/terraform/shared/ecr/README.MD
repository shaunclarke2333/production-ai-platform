# shared/ecr: ECR

The ECR repo that will hold the the images for the production ai platform

## Why it's built this way
- Built from a module, because it's a shared resourced that can be spun up easily if another is needed.
- Policy that expires untagged images older than 30 days. This automatically keeps the repo clean and uptodate.
- Policy also keeps only the last 20 tagged images.
- Imuutable tags paired with commit-SHA tagging, so an image can never be overwritten and every deployment traces to an exact commit.

## Depends on
- This depends on the ecr module located at modules/ecr

## Inputs / outputs
- Inputs: ecr_repo_name, ecr_image_tag_mutability, ecr_encryption_type, ecr_image_scan_on_push, ecr_repo_tags
- Outputs: repository_url

## How to apply
```bash
cd infra/terraform/shared/ecr
terraform init
terraform apply
```
