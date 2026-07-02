resource "aws_vpc" "main_vpc" {
  # Specifying the CIDR block for the VPC
  cidr_block = var.main_vpc_cidr

  # Enabling DNS support and hostnames for the VPC
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.tags
}