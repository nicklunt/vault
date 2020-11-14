output "Vault-Public-IP" {
  value = aws_instance.vault.public_ip
}

output "UnsealKeyID" {
  value = aws_kms_key.vault-unseal-key.key_id
}

output "UnsealKeyARN" {
  value = aws_kms_key.vault-unseal-key.arn
}

output "DBTable" {
  value = aws_dynamodb_table.vault-table.arn
}