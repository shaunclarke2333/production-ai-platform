terraform {
  # Terraform version requirement
  required_version = "~> 1.15.7"

  # Required providers
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.52.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~> 3.2.0"
    }
    
  }
}

provider "aws" {
  region = var.region
  
}

# Resource block that initilizes helm
provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

