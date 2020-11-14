#!/bin/bash

set -xe 

# Send userdata to log
[[ ! -d /var/log/userdata ]] && mkdir -p /var/log/userdata/
exec > >(tee /var/log/userdata/userdata.log | logger -t user-data -s 2>/dev/console) 2>&1

# Get vault from hashicorp
# wget https://releases.hashicorp.com/vault/1.5.5/vault_1.5.5_linux_amd64.zip  -O /tmp/vault.zip
wget https://releases.hashicorp.com/vault/1.6.0/vault_1.6.0_linux_amd64.zip -O /tmp/vault.zip

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
export VAULT_SKIP_VERIFY=true
EOF

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

export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_SKIP_VERIFY=true

systemctl start vault
sleep 20

## Initialise and auto unseal vault
vault operator init -recovery-shares=1 -recovery-threshold=1 2>&1 | tee ~/vault-init-out.txt
sleep 20
vault status | tee -a ~/vault-status.txt

## Vault should now be running and unsealed

# Set the VAULT_TOKEN var so we can interact with vault
VAULT_TOKEN=$(grep '^Initial Root Token:' ~/vault-init-out.txt | awk '{print $NF}')
# Now remove the root token from the system
# rm -rf ~/vault-init-out.txt

# Enable logging
mkdir /var/log/vault
chown vault:vault /var/log/vault
vault audit enable file file_path=/var/log/vault/vault.log

# Now vault is up and running, we want to give the instance role of the vault server 
# the ability to login with the AWS auth engine.

# install jq - AWS yum repos are not reliable for this, so grab it from github
wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod +x jq-linux64
mv jq-linux64 /usr/bin/jq

# Our account ID
account_id=$(curl -Ss http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.accountId')

# Our instance role
vault_instance_role="arn:aws:iam:${region}:$${account_id}:role/${instance-role}"

# Use the root token to setup the admin policy, after which we can remove the root token from the server.
VAULT_TOKEN=$(grep '^Initial Root Token:' ~/vault-init-out.txt | awk '{print $NF}')

# Create the admin policy
# vault policy write "admin-policy" 
