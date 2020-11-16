#!/bin/bash

set -xe 

# Send userdata to log
[[ ! -d /var/log/userdata ]] && mkdir -p /var/log/userdata/
exec > >(tee /var/log/userdata/userdata.log | logger -t user-data -s 2>/dev/console) 2>&1

# install jq - I found AWS yum repos are not reliable for this, so grab it from github
wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod +x jq-linux64
mv jq-linux64 /usr/bin/jq

# Get vault from hashicorp
wget https://releases.hashicorp.com/vault/1.5.5/vault_1.5.5_linux_amd64.zip  -O /tmp/vault.zip
# wget https://releases.hashicorp.com/vault/1.6.0/vault_1.6.0_linux_amd64.zip -O /tmp/vault.zip

# Unzip /tmp/vault.zip to /usr/bin/vault
unzip /tmp/vault.zip -d /usr/bin/

# Setup vault user
groupadd --force --system vault
if ! getent passwd vault >/dev/null; then
    adduser --system --gid vault --no-create-home --comment "vault owner" --shell /bin/false vault >/dev/null
fi

# Login profile
cat << EOF > /etc/profile.d/vault.sh
export VAULT_ADDR=http://127.0.0.1:8200
EOF
# export VAULT_SKIP_VERIFY=true

# Systemd service for vault
cat > /usr/lib/systemd/system/vault.service <<-EOF
[Unit]
Description=Vault Service
Requires=network-online.target
After=network-online.target
[Service]
Restart=on-failure
PermissionsStartOnly=true
ExecStartPre=/sbin/setcap 'cap_ipc_lock=+ep' /bin/vault
ExecStart=/bin/vault server -config /etc/vault/vault.conf
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
User=vault
Group=vault
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable vault

# The vault config file
mkdir /etc/vault
cat > /etc/vault/vault.conf <<-EOF
listener "tcp" {
    address = "0.0.0.0:8200"
    tls_disable = 1
}

ui = true

storage "dynamodb" {
    region          = "${region}"
    table           = "${dynamodb-table}"
    read_capacity   = 3
    write_capacity  = 3
}

seal "awskms" {
    region      = "${region}"
    kms_key_id  = "${unseal-key}"
}
EOF

chown -R vault:vault /etc/vault
chmod -R 0644 /etc/vault/*

mkdir /var/log/vault
chown vault:vault /var/log/vault

# export VAULT_SKIP_VERIFY=true

systemctl start vault

sleep 30

export VAULT_ADDR=http://127.0.0.1:8200

# Check if vault is already initialised
INITIALIZED=$(curl $VAULT_ADDR/v1/sys/init | jq '.initialized')
if [ "$${INITIALIZED}" != "true" ]; then
    echo "[] Vault DB not initialised, initialising now"
    ## Initialise vault and save token and unseal key
    vault operator init -recovery-shares=1 -recovery-threshold=1 2>&1 | tee ~/vault-init-out.txt
    sleep 20
    echo "[] Vault status output"
    vault status | tee -a ~/vault-status.txt

    # Set the VAULT_TOKEN var so we can interact with vault
    export VAULT_TOKEN=$(grep '^Initial Root Token:' ~/vault-init-out.txt | awk '{print $NF}')

    # Save the root token to aws secrets manager

else
    # Vault already initialised, which means the db is up which has our role, so login with that role, then exit this script.
    echo "[] Vault DB already initialised. Check we can login with aws method."
    vault login -method=aws role=admin
    exit
fi


# Now remove the root token from the system
# rm -rf ~/vault-init-out.txt

# Enable vault logging
vault audit enable file file_path=/var/log/vault/vault.log

# Now vault is up and running, we want to give the instance role of the vault server 
# the ability to login with the AWS auth engine.

# Our instance role. Used to give this instance access to vault with the AWS engine
# vault_instance_role="arn:aws:iam:${region}:$(curl -Ss http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.accountId'):role/${instance-role}"

# Enable the vault AWS engine
vault auth enable aws
vault secrets enable -path=secret -version=2 kv

# Get the vault-admin-policy.hcl file that was uploaded to S3 in s3.tf
aws s3 cp s3://${vault_bucket}/vault-admin-policy.hcl /var/tmp/

# Create the admin policy
vault policy write "admin-policy" /var/tmp/vault-admin-policy.hcl

# Give this instance admin privileges to vault, tied to vault_instance_role.
vault write \
    auth/aws/role/admin \
    auth_type=iam \
    policies=admin-policy \
    max_ttl=1h \
    bound_iam_principal_arn=${vault_instance_role}

