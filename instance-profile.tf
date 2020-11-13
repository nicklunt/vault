resource "aws_iam_instance_profile" "vault-profile" {
  name = "vault-profile"
  role = aws_iam_role.vault-role.name
}

resource "aws_iam_role" "vault-role" {
  name = "vault-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "dynamodb.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "dynamodb-policy-doc" {
  statement {
    sid = "dynamodb"

    actions = [
      "dynamodb:Get*",
      "dynamodb:Describe*",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:CreateTable",
      "dynamodb:Delete",
      "dynamodb:Update",
      "dynamodb:PutItem"
    ]
    resources = [
      "arn:aws:dynamodb:::${var.dynamodb-table}"
    ]

  }
}

resource "aws_iam_policy" "dynamodb-policy" {
  name   = "dynamodb-policy"
  policy = data.aws_iam_policy_document.dynamodb-policy-doc.json
}

resource "aws_iam_policy_attachment" "dynamodb-attach" {
  name       = "vault-dynamodb-policy-attach"
  roles      = [aws_iam_role.vault-role.name]
  policy_arn = aws_iam_policy.dynamodb-policy.arn
}
