# This is the key that vault uses to unseal itself.

resource "aws_kms_key" "vault-unseal-key" {
  description             = "KMS Key to unseal Vault"
  deletion_window_in_days = 7
}

# An alias for the key
resource "aws_kms_alias" "vault-kms-alias" {
  name = "alias/vault-unseal-key"
  target_key_id = aws_kms_key.vault-unseal-key.id
}