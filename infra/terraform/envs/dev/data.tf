data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.name
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}

# querying aws for the exact addon version that matches the cluster version
data "aws_eks_addon_version" "ebs_csi_136" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = var.eks_version # Hardcodes the target cluster lifecycle version
}

# This allows us to access outputs from the VPC remote state file in this environment.
# This is necessary because the VPC is created in a separate environment and we need to reference its outputs here.
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = var.vpc_state_key
    region = var.region
  }
}
