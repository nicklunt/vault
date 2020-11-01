  resource "aws_iam_instance_profile" "vault-profile" {
    name = "vault-profile"
    role = aws_iam_role.vault-role.name
  }

  resource "aws_iam_role" "vault-role" {
    name = "vault-role"
    path = "/"

    assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
        "Statement": [
            {
            "Action": [
                "dynamodb:DescribeLimits",
                "dynamodb:DescribeTimeToLive",
                "dynamodb:ListTagsOfResource",
                "dynamodb:DescribeReservedCapacityOfferings",
                "dynamodb:DescribeReservedCapacity",
                "dynamodb:ListTables",
                "dynamodb:BatchGetItem",
                "dynamodb:BatchWriteItem",
                "dynamodb:CreateTable",
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:GetRecords",
                "dynamodb:PutItem",
                "dynamodb:Query",
                "dynamodb:UpdateItem",
                "dynamodb:Scan",
                "dynamodb:DescribeTable"
            ],
            "Effect": "Allow",
            "Sid": "Vault"
            }
        ]
    }
EOF
}