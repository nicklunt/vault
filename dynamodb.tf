# This creates the dynamodb table used by vault to store its data
resource "aws_dynamodb_table" "vault-table" {
  name           = var.dynamodb-table
  read_capacity  = var.dynamo-read-write
  write_capacity = var.dynamo-read-write
  hash_key       = "Path"
  range_key      = "Key"
  attribute {
    name = "Path"
    type = "S"
  }

  attribute {
    name = "Key"
    type = "S"
  }

  tags = {
    Name = "vault-table"
  }
}