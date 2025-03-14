#!/bin/bash

# Install packages
sudo apt-get update
sudo apt-get install -y git gnupg2 software-properties-common openssh-server

# Install Hashicorp Packer
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install -y packer
packer plugins install github.com/hashicorp/proxmox

# Create new user
NEW_USER="provisioner"
PASSWORD="provisioner"

# Create user with home directory
useradd -m -s /bin/bash $NEW_USER

# Set password
echo "$NEW_USER:$PASSWORD" | chpasswd

# Create SSH directory
USER_HOME="/home/$NEW_USER"
SSH_DIR="$USER_HOME/.ssh"
mkdir -p $SSH_DIR

# Generate SSH keypair
ssh-keygen -t rsa -b 4096 -f "$SSH_DIR/id_rsa" -N "" -C "$NEW_USER@container"

# Set proper permissions
chown -R $NEW_USER:$NEW_USER $SSH_DIR
chmod 700 $SSH_DIR
chmod 600 "$SSH_DIR/id_rsa"
chmod 644 "$SSH_DIR/id_rsa.pub"

# Add to sudo group
usermod -aG sudo $NEW_USER

# Verify installations
git --version
packer --version
echo "Public SSH key:"
cat "$SSH_DIR/id_rsa.pub"
