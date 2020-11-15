data "template_file" "userdata" {
  template = "${file("${path.module}/templates/vault.sh.tpl")}"

  vars = {
    region         = var.region
    dynamodb-table = var.dynamodb-table
    unseal-key     = aws_kms_key.vault-unseal-key.id
    instance-role  = aws_iam_role.vault-kms-unseal.name
    vault_instance_role="arn:aws:iam:${var.region}:${var.account_id}:role/${aws_iam_role.vault-kms-unseal.name}"
  }
}
