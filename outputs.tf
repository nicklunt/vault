# The public ip of the vault instance.
output "Vault-Public-IP" {
  value = "ssh ec2-user@${aws_instance.vault.public_ip}"
}

# Show how to authenticate to vault from the vault instance.
output "Authenticate-To-Vault" {
  value = "vault login -method=aws role=admin"
}

