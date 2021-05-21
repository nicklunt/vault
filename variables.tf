
# Change region for your env
variable "region" {
  type    = string
  default = "eu-west-2"
}

# Change this to your aws account
variable "account_id" {
  description = "AWS Account ID - REMOVE BEFORE PUBLISHING"
  type        = string
  default     = "329035065473"
}

# Change this to your external IP
variable "my_ip" {
  description = "my external IP address"
  type        = string
  default     = "86.23.82.87/32"
}

# May need to change the AMI if not in eu-west-2
variable "ami" {
  description = "eu-west-2 Amazon Linux 2 AMI"
  type        = string
  default     = "ami-0a669382ea0feb73a"
}

# May need to change the bucket to something unique
variable "bucket_name" {
  description = "Bucket to upload any required files"
  type        = string
  default     = "vault-conf-bucket-01010101"
}

variable "ssh-key" {
  type        = string
  description = "File holding my public ssh key: ssh-keygen -y -f ~/.ssh/id_rsa > public_key"
  default     = "public-key"
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

variable "dynamodb-table" {
  type    = string
  default = "vault-table"
}

variable "dynamo-read-write" {
  description = "Read / Write value"
  default     = 1
}

variable "vault-secret-name" {
  description = "Name of the secrets manager secret to save the vault root token to"
  default     = "vault-secrets"
}

variable "instance-role" {
  default = "vault-role"
}

variable "instance-role-policy" {
  default = "vault-role-policy"
}

variable "instance-profile" {
  default = "vault-instance-profile"
}

variable "ingress-rules" {
  type    = list(number)
  default = [22, 8200]
}

variable "egress-rules" {
  type    = list(number)
  default = [80, 443]
}
