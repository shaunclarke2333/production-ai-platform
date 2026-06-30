provider "aws" {
  region = "us-west-2"
}

terraform {
  # Terraform version requirement
  required_version = "~> 1.15.7"

  # Required providers
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.52.0"
    }
  }
}
