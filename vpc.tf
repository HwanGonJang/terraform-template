resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}


# Default route table
resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = {
    Name = "${var.project_name}-${var.environment}-default-rtb"
  }
}

# Default security group
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-default-sg"
  }
}

# Default network access list
resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  tags = {
    Name = "${var.project_name}-${var.environment}-default-nacl"
  }
}

# Subnet
## public1-subnet
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-2a"
  cidr_block              = var.cidr_public1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public1-subnet"
  }
}

# Route table
## public1
resource "aws_route_table" "public1" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-public1-rtb"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public1.id
}

resource "aws_route" "public1" {
  route_table_id         = aws_route_table.public1.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# NACL
## public1
resource "aws_network_acl" "public1" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.public1.id]

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public2-nacl"
  }
}

## public2-subnet
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-2c"
  cidr_block              = var.cidr_public2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public2-subnet"
  }
}

# Route table
## public1
resource "aws_route_table" "public2" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-public2-rtb"
  }
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public2.id
}

resource "aws_route" "public2" {
  route_table_id         = aws_route_table.public2.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# NACL
## public1
resource "aws_network_acl" "public2" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.public2.id]

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public2-nacl"
  }
}