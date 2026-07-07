variable "region" {
  description = "The region where the S3 bucket will be built"
  type        = string
}

variable "state_bucket" {
  description = "s3 bucket for the remote state"
  type        = string
}

variable "vpc_state_key" {
  description = "Key for the vpc remote state"
  type        = string
}

variable "eks_version" {
  description = "The version of EKS the cluster will use"
  type        = string
}

variable "tags" {
  description = "EKS cluster environment tags"
  type        = map(string)
}

variable "node_group_name" {
  description = "The name of the node group"

}

variable "general_nodes_ec2_types" {
  description = "The size of the EC2 instances for the cluster"
  type        = list(string)
}

variable "general_nodes_count" {
  description = "The number of nodes to be available at any given time"
  type        = string
}
