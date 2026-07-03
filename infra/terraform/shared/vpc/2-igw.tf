resource "aws_internet_gateway" "igw" {
  # Specifying the VPC ID for the intnet gateway to be attached to.
  vpc_id = aws_vpc.main_vpc.id

  tags = var.tags

}
