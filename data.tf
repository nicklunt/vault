data "template_file" "userdata" {
  template = "${file("${path.module}/templates/vault.sh.tpl")}"

  vars = {
    region         = var.region
    dynamodb-table = var.dynamodb-table
    unseal-key     = aws_kms_key.vault-unseal-key.id
  }
}