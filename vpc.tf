# VPC
resource "aws_vpc" "this" {
    cidr_block = var.vpc-cidr

    tags = {
        Name = "Vault VPC"
    }
}

# Public Subnet
resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.this.id
    cidr_block = var.public-cidr

    tags = {
        Name = "Vault Public Subnet"
    }
}

# Security Group
resource "aws_security_group" "sg-vault" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "Vault SG"
    }

    dynamic "ingress" {
        for_each = var.ingress-rules
        iterator = port 
        content {
            from_port = port.value
            to_port = port.value
            protocol = "TCP"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    dynamic "egress" {
        for_each = var.egress-rules 
        iterator = port
        content {
            from_port = port.value
            to_port = port.value
            protocol = "TCP"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
}

# # Internet Gateway
# resource "aws_internet_gateway" "vault-gateway" {
#     vpc_id = aws_vpc.this.id

#     tags = {
#         Name = "Vault Internet Gateway"
#     }
# }

