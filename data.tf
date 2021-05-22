# The template file 'vault.sh' gets run as userdata.
# This template_file data populates any ${var} varabiles in that script.
data "template_file" "userdata" {
  template = file("${path.module}/templates/vault.sh.tpl")

  vars = {
    region              = var.region
    dynamodb-table      = var.dynamodb-table
    unseal-key          = aws_kms_key.vault-unseal-key.id
    instance-role       = aws_iam_role.vault-kms-unseal.name
    vault_instance_role = "arn:aws:iam:${var.region}:${var.account_id}:role/${aws_iam_role.vault-kms-unseal.name}"
    vault_bucket        = var.bucket_name
    secret-name         = var.vault-secret-name
    secret_id           = aws_secretsmanager_secret.vault-root-token.id
  }
}
