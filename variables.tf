################### CHANGE THESE VARS TO SUIT YOUR ENVIRONMENT ###################

# Change region for your env
variable "region" {
  type    = string
  default = "eu-west-2"
}

# Change this to your aws account
variable "account_id" {
  description = "AWS Account ID - REMOVE BEFORE PUBLISHING"
  type        = string
  default     = "01234567890"
}

# Change this to your external IP
variable "my_ip" {
  description = "my external IP address"
  type        = string
  default     = "aa.bb.cc.dd/32"
}

# May need to change the AMI if not in eu-west-2
variable "ami" {
  description = "eu-west-2 Amazon Linux 2 AMI"
  type        = string
  default     = "ami-0a669382ea0feb73a"
}

# I'm using a small instance type for testing
variable "aws_instance_type" {
  description = "aws instance type"
  type        = string
  default     = "t2.micro"
}

# Size of the OS volume
variable "root_volume_size" {
  description = "size of the os volume in GB"
  type        = string
  default     = "50"
}

# May need to change the bucket to something unique
variable "bucket_name" {
  description = "Bucket to upload any required files"
  type        = string
  default     = "vault-conf-bucket-01010101"
}

# If running terraform from linux, generate the ssh-key with 
# cd <vault terraform directory>
# ssh-keygen -y -f ~/.ssh/id_rsa > public_key
variable "ssh-key" {
  type        = string
  description = "File holding my public ssh key: ssh-keygen -y -f ~/.ssh/id_rsa > public_key"
  default     = "public-key"
}

################### VARS BELOW SHOULD BE OK AS THEY ARE ###################

variable "vpc-cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "public-cidr" {
  description = "Public CIDR"
  default     = "10.0.1.0/24"
}

variable "private-subnet" {
  description = "Private CIDR"
  default     = "10.0.2.0/24"
}

variable "dynamodb-table" {
  description = "DynamoDB table name"
  type        = string
  default     = "vault-table"
}

variable "dynamo-read-write" {
  description = "Read / Write value"
  default     = 1
}

variable "vault-root-token" {
  description = "Name of the secrets manager secret to save the vault root token to"
  default     = "vault-root-token"
}

variable "vault-recovery-key" {
  description = "Name of the secrets manager secret to save the vault recovery key to"
  default     = "vault-recovery-key"
}

variable "instance-role" {
  description = "The instance role"
  default     = "vault-role"
}

variable "instance-role-policy" {
  description = "The policy"
  default     = "vault-role-policy"
}

variable "instance-profile" {
  description = "The profile"
  default     = "vault-instance-profile"
}

variable "ingress-rules" {
  description = "Allow SSH and Vault Port inbound"
  type        = list(number)
  default     = [22, 8200]
}

variable "egress-rules" {
  description = "Allow HTTP and HTTPS outbound"
  type        = list(number)
  default     = [80, 443]
}
