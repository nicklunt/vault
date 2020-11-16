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

output "InstanceRoleName" {
  value = aws_iam_role.vault-kms-unseal.name
}

output "vault_instance_role" {
  value = "arn:aws:iam:${var.region}:${var.account_id}:role/${aws_iam_role.vault-kms-unseal.name}"
}