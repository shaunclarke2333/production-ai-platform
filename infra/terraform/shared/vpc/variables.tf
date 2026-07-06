variable "region" {
  description = "The region the VPC will be built in"
  type        = string
}

variable "zones" {
  description = "Availability zones for the subnets"
  type        = list(string)
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "main_vpc_cidr" {
  description = "The CIDR range for the VPC"
  type        = string
}

variable "tags" {
  description = "Tags that will be used by the VPC"
  type        = map(string)
}
