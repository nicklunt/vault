#!/bin/bash

# Get vault from hashicorp
wget https://releases.hashicorp.com/vault/1.5.5/vault_1.5.5_linux_amd64.zip  -O /tmp/vault.zip

# Unzip /tmp/vault.zip to /usr/bin/vault
unzip /tmp/vault.zip -d /usr/bin/



