variable "region" {
  description = "The region where the S3 bucket will be built"
  type        = string
}

variable "state_bucket" {
  description = "s3 bucket for the remote state"
  type = string
}

variable "vpc_state_key" {
  description = "Key for the vpc remote state"
  type = string
}