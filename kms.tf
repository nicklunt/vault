# This is the key that vault uses to unseal itself.
resource "aws_kms_key" "vault-unseal-key" {
  description             = "KMS Key to unseal Vault"
  deletion_window_in_days = 7
}
