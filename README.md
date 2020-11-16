## Setup a Hashicorp Vault server which 
- [x] Installs Hashicorp Vault
- [x] Uses AWS KMS to unseal 
- [x] Vault data is stored on AWS DynamoDB
- [x] Root token and recovery key stored in AWS Secrets Manager
- [x] AWS Auth used with instance profile to login to vault
- [x] Logic to check if db is already initialised and behave accordingly

### Generate public key from private key
*ssh-keygen -y -f ~/.ssh/id_rsa > public_key*

