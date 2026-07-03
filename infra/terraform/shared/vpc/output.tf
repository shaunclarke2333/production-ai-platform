output "vpc_id" {
    description = "ID of the VPC created earlier"
    value = aws_vpc.main_vpc.id
}

output "private_subnet_ids" {
    description = "IDs for the private subents"
    value = [aws_subnet.private_zone1.id, aws_subnet.private_zone2.id]
}

output "public_subnet_ids" {
    description = "IDs for public subnets"
    value = [aws_subnet.public_zone1.id, aws_subnet.public_zone2.id]
}