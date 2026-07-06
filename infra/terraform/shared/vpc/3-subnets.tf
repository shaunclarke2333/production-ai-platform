resource "aws_subnet" "private_zone1" {
  vpc_id = aws_vpc.main_vpc.id
  # Take the main vpc_cidr, the number 4 means split it into 2^4 = 16 subnets and use the first one
  cidr_block = cidrsubnet(var.main_vpc_cidr, 4, 0)
  # Selecting the first availabilty zone from the list of zones provided in the .tfvars file
  availability_zone = var.zones[0]

  tags = {
    Name        = "${var.tags["Name"]}-private-${var.zones[0]}"
    Environment = var.tags["Environment"]
    Project     = var.tags["Project"]
    # This tag is used by EKS to identify which subnets should be used for internal load balancers.
    "kubernetes.io/role/internal-elb" = "1"
    # This tag essentially tells EKS that this subnet is owned by the cluster and should be used for worker nodes and internal load balancers
    "kubernetes.io/cluster/${var.tags["Name"]}-eks-cluster" = "owned"
  }
}

resource "aws_subnet" "private_zone2" {
  vpc_id = aws_vpc.main_vpc.id
  # Take the main vpc_cidr, the number 4 means split it into 2^4 = 16 subnets and use the second one
  cidr_block        = cidrsubnet(var.main_vpc_cidr, 4, 1)
  availability_zone = var.zones[1]

  tags = {
    Name        = "${var.tags["Name"]}-private-${var.zones[1]}"
    Environment = var.tags["Environment"]
    Project     = var.tags["Project"]
    # This tag is used by EKS to identify which subnets should be used for internal load balancers.
    "kubernetes.io/role/internal-elb" = "1"
    # This tag essentially tells EKS that this subnet is owned by the cluster and should be used for worker nodes and internal load balancers
    "kubernetes.io/cluster/${var.tags["Name"]}-eks-cluster" = "owned"
  }

}

resource "aws_subnet" "public_zone1" {
  vpc_id = aws_vpc.main_vpc.id
  # Take the main vpc_cidr, the number 4 means split it into 2^4 = 16 subnets and take the third one
  cidr_block        = cidrsubnet(var.main_vpc_cidr, 4, 2)
  availability_zone = var.zones[0]
  # Allows AWS to automatically assign public IPs to instances launched in this subnet
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.tags["Name"]}-public-${var.zones[0]}"
    Environment = var.tags["Environment"]
    Project     = var.tags["Project"]
    # Eks uses this tag to identify which subnets to create public load balancers
    "kubernetes.io/role/elb"                                = "1"
    "kubernetes.io/cluster/${var.tags["Name"]}-eks-cluster" = "owned"
  }

}

resource "aws_subnet" "public_zone2" {
  vpc_id = aws_vpc.main_vpc.id
  # Take the main vpc_cidr, the number 4 means split it into 2^4 = 16 subnets and take the fourth one
  cidr_block        = cidrsubnet(var.main_vpc_cidr, 4, 3)
  availability_zone = var.zones[1]
  # Allows AWS to automatically assign public IPs to instances launched in this subnet
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.tags["Name"]}-public-${var.zones[1]}"
    Environment = var.tags["Environment"]
    Project     = var.tags["Project"]
    # Eks uses this tag to identify which subnets to create public load balancers
    "kubernetes.io/role/elb"                                = "1"
    "kubernetes.io/cluster/${var.tags["Name"]}-eks-cluster" = "owned"
  }

}
