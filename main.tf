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
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.sg-vault.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.vault-kms-unseal.name
  user_data                   = data.template_file.userdata.rendered

  root_block_device {
    volume_size = 300
  }

  tags = {
    Name = "Vault Server"
  }

  # The vault instance needs the unseal key and dynamodb table in place before it launches.
  depends_on = [aws_kms_key.vault-unseal-key, aws_dynamodb_table.vault-table]
}

resource "aws_ebs_volume" "vault-volume" {
  availability_zone = aws_instance.vault.availability_zone
  size              = 50
  encrypted         = true
  #kms_key_id          = var.somekey
}

resource "aws_volume_attachment" "vault-volume-attachment" {
  device_name = "/dev/xvdb"
  instance_id = aws_instance.vault.id
  volume_id   = aws_ebs_volume.vault-volume.id
}


