# Remote state backend config for ecr module
terraform {
  backend "s3" {
    bucket = "prod-ai-platform-terraform-state"
    key    = "iam-oidc/terraform.tfstate"
    region = "us-west-2"

    # Enabling native S3 state locking
    use_lockfile = true
  }
}
