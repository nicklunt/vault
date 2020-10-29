# Key Pair generated from our private key
resource "aws_key_pair" "ssh-keypair" {
    key_name = "ssh-keypair"
    public_key = file(var.ssh-key)
}

# EC2 instance for the vault server
resource "aws_instance" "vault" {
    ami = var.ami
    key_name = aws_key_pair.ssh-keypair.id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public-subnet.id
    vpc_security_group_ids = [aws_security_group.sg-vault.id]
    associate_public_ip_address = true

    user_data = file("vault.sh")
    
    tags = {
        Name = "Vault Server"
    }
}