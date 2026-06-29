# ECR repo variables
variable "ecr_repo_name" {
  description = "The name of the ECR repository"
  type        = string
  
}

variable "ecr_image_tag_mutability" {
  description = "Image mutability status"
  type = string

}

variable "ecr_encryption_type" {
  description = "The encryption type for the ECR repo"
  type = string

}

variable "ecr_image_scan_on_push" {
  description = "whether to scan images on push"
  type = bool
  
}

variable "ecr_repo_tags" {
  description = "Tags that apply to the ECR repo"
  type = map(string)

}
