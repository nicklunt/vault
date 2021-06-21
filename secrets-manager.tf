# The vault root token and recovery key saved to AWS secrets manager

resource "aws_secretsmanager_secret" "vault-root-token" {
  name        = var.vault-root-token
  description = "Vault root token"
  # recovery set to 0 so we can recreate the secret as required for testing.
  recovery_window_in_days = 0
  tags = {
    Name = var.vault-root-token
  }
}

resource "aws_secretsmanager_secret" "vault-recovery-key" {
  name        = var.vault-recovery-key
  description = "Vault recovery key"
  # recovery set to 0 so we can recreate the secret as required for testing.
  recovery_window_in_days = 0
  tags = {
    Name = var.vault-recovery-key
  }
}
