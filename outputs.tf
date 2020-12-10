output "Vault-Public-IP" {
  value = "ssh ec2-user@${aws_instance.vault.public_ip}"
}

output "Authenticate-To-Vault" {
  value = "vault login -method=aws role=admin"
}

