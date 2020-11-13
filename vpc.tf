# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = "Vault VPC"
  }
}

# Public Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public-cidr

  tags = {
    Name = "Vault Public Subnet"
  }
}

# Route Table for IG
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vault-gateway.id
  }

  tags = {
    Name = "Public Gateway"
  }
}

# Associate the Route Table with our public subnet
resource "aws_route_table_association" "public-assoc" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

# Security Group
resource "aws_security_group" "sg-vault" {
  vpc_id = aws_vpc.this.id
  name   = "Vault SG"
  tags = {
    Name = "Vault SG"
  }

  dynamic "ingress" {
    for_each = var.ingress-rules
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.egress-rules
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

# Internet Gateway
resource "aws_internet_gateway" "vault-gateway" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "Vault Internet Gateway"
  }
}

