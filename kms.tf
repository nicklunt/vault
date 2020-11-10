resource "aws_kms_key" "vault-unseal-key" {
  description             = "KMS Key to unseal Vault"
  deletion_window_in_days = 10
}
