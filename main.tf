# Key pair generated from our own ssh key so we can ssh to the instance
# ssh-keygen -y -f ~/.ssh/id_rsa > public_key

resource "aws_key_pair" "ssh-keypair" {
  key_name   = "ssh-keypair"
  public_key = file(var.ssh-key)
}

# EC2 instance for the vault server
resource "aws_instance" "vault" {
  ami                         = var.ami
  key_name                    = aws_key_pair.ssh-keypair.id
  instance_type               = var.aws_instance_type
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.sg-vault.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.vault-kms-unseal.name
  user_data                   = data.template_file.userdata.rendered

  root_block_device {
    volume_size = var.root_volume_size
  }

  tags = {
    Name = "Vault Server"
  }

  # The vault instance needs the unseal key and dynamodb table in place before it launches.
  depends_on = [aws_kms_key.vault-unseal-key, aws_dynamodb_table.vault-table]
}

