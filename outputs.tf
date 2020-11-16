output "Vault-Public-IP" {
  value = "To connect: ssh ec2-user@${aws_instance.vault.public_ip}"
}

output "Login-To-Vault" {
  value = "vault login -method=aws role=admin"
}