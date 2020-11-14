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

systemctl start vault
sleep 10
systemctl restart vault
sleep 10

systemctl status vault | tee ~/vault-systemd-status.txt

## Initialise and auto unseal vault
vault operator init -recovery-shares=1 -recovery-threshold=1 | tee ~/vault-init-out.txt

