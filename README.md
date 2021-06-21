## Setup a Hashicorp Vault server with Terraform 1.0 which ..
- [x] Installs Hashicorp Vault
- [x] Uses AWS KMS to unseal 
- [x] Vault data is stored on AWS DynamoDB
- [x] Root token and recovery key stored in AWS Secrets Manager
- [x] AWS Auth used with instance profile to login to vault
- [x] Logic to check if dynamoDB backend is already initialised and behave accordingly

### Get vault root token
*aws secretsmanager get-secret-value --secret-id vault-root-token | jq -r '.SecretString'

### Generate public key from private key which is then used to ssh as ec2-user to the vault instance.
*cd this_repo_dir
*ssh-keygen -y -f ~/.ssh/id_rsa > public_key*

