# This is the bucket where anything required by the userdata will be uploaded to.
# The userdata will then pull these objects down as required.
resource "aws_s3_bucket" "vault_config_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

# Upload the vauld admin policy to S3
resource "aws_s3_bucket_object" "vault_admin_policy" {
  bucket = aws_s3_bucket.vault_config_bucket.id
  key    = "vault-admin-policy.hcl"
  source = "templates/vault-admin-policy.hcl"
}

