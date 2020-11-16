variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "account_id" {
  description = "AWS Account ID - REMOVE BEFORE PUBLISHING"
  default     = "329035065473"
}

variable "ssh-key" {
  type        = string
  description = "File holding my public ssh key"
  default     = "public-key"
}

variable "ami" {
  description = "eu-west-2 London Amazon Linux 2 AMI"
  default     = "ami-0a669382ea0feb73a"
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "public-cidr" {
  default = "10.0.1.0/24"
}

variable "private-subnet" {
  default = "10.0.2.0/24"
}

variable "ingress-rules" {
  type    = list(number)
  default = [22, 8002, 443]
}

variable "egress-rules" {
  type    = list(number)
  default = [22, 8002, 443]
}

variable "dynamodb-table" {
  type    = string
  default = "vault-table"
}

variable "bucket_name" {
  description = "Bucket to upload any required files"
  default     = "vault-conf-bucket-01010101"
}

variable "vault-secret-name" {
  description = "Name of the secrets manager secret to save the vault root token to"
  default     = "nl-secret-10"
}