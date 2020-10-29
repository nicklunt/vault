- install vault 
- [ ] Create DynamoDB table
- [ ] Create IAM instance role so instance can access DynamoDB and KMS
- [ ] Create unseal KMS key
- [ ] Install and config vault in user_data

## Setup a Hashicorp Vault server which uses AWS KMS to unseal, and the vault data is stored on AWS DynamoDB.

### Vault instance IAM Profile
* KMS
* DynamoDB

### Generate public key from out private key
*ssh-keygen -y -f ~/.ssh/id_rsa > public_key*


