## Todo
- ~~Setup VPC and SGs~~
- ~~create instance with some user_data for vault install~~
- ~~install vault~~
- ~~ Create DynamoDB table
- ~~ Create IAM instance role so instance can access DynamoDB and KMS
- ~~ Create unseal KMS key
- ~~ Update user_data to configure vault
- ~~ Save root toke to AWS secrets manager

## Setup a Hashicorp Vault server which uses AWS KMS to unseal, and the vault data is stored on AWS DynamoDB.

### Vault instance IAM Profile
* KMS
* DynamoDB

### Generate public key from private key
*ssh-keygen -y -f ~/.ssh/id_rsa > public_key*


