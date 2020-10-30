#!/bin/bash

# Get vault from hashicorp
wget https://releases.hashicorp.com/vault/1.5.5/vault_1.5.5_linux_amd64.zip  -O /tmp/vault.zip

# Unzip /tmp/vault.zip to /usr/bin/vault
unzip /tmp/vault.zip -d /usr/bin/

# Create systemd for vault
cat > /usr/lib/systemd/system/vault.service <<-EOF
[Unit]
Description=Vault service
After=network-online.target

[Service]
PrivateDevices=yes
PrivateTmp=yes
ProtectSystem=full
ProtectHome=read-only
SecureBits=keep-caps
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/bin/vault server -config=/etc/vault/vault.conf
KillSignal=SIGINT
TimeoutStopSec=30s
Restart=on-failure
StartLimitInterval=60s
StartLimitBurst=3

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
    region = "eu-west-2"
    table = "vault-data"
    read_capacity = 3
    write_capacity = 3
}
EOF
