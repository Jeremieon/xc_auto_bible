# AWS Public IP
resource "aws_eip" "aws_ce" {
  domain = "vpc"
  tags = {
    Name = "aws-ce-public-ip"
  }
}

# AWS VPC and subnets (simplified)
resource "aws_vpc" "aws_ce_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "aws-ce-vpc"
  }
}

resource "aws_subnet" "aws_outside" {
  vpc_id     = aws_vpc.aws_ce_vpc.id
  cidr_block = "10.1.1.0/24"
  tags = {
    Name = "aws-outside-subnet"
  }
}

resource "aws_subnet" "aws_inside" {
  vpc_id     = aws_vpc.aws_ce_vpc.id
  cidr_block = "10.1.2.0/24"
  tags = {
    Name = "aws-inside-subnet"
  }
}

resource "aws_internet_gateway" "aws_igw" {
  vpc_id = aws_vpc.aws_ce_vpc.id
}
