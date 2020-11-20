resource "aws_secretsmanager_secret" "vault-root-token" {
  name                    = var.vault-secret-name
  description             = "Vault root token"
  recovery_window_in_days = 0
  tags = {
    Name = var.vault-secret-name

  }
}

