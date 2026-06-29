# Remote state backend config for the entire project
terraform {
  backend "s3" {
    bucket = "prod-ai-platform-terraform-state"
    key    = "bootstrap/terraform.tfstate"
    region = "us-west-2"

    # Enabling native S3 state locking
    use_lockfile = true
  }
}
