resource "aws_s3_bucket" "vault_config_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_object" "vault_admin_policy" {
  bucket = aws_s3_bucket.vault_config_bucket.id
  key    = "vault-admin-policy.hcl"
  source = "templates/vault-admin-policy.hcl"
}

