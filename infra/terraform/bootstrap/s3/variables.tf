# s3 bucket region
variable "bucket_region" {
  description = "The region where the S3 bucket will be built"
  type        = string
}

# S3 bucket name variable
variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

# bucket tags variable
variable "bucket_tags" {
  description = "The tags that will be used for the state bucket"
  type        = map(string)
}
