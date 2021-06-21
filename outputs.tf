# The public ip of the vault instance.
output "Connect_to_vault_instance" {
  value = "ssh ec2-user@${aws_instance.vault.public_ip}"
}

# Show how to authenticate to vault from the vault instance.
output "Authenticate_to_vault" {
  value = "vault login -method=aws role=admin"
}

# Connect to Vault UI
output "Connect_to_vault_UI" {
  value = "http://${aws_instance.vault.public_ip}:8200"
}
