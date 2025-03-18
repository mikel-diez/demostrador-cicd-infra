#!/bin/bash

# This will be downloaded and executed at boot time
export DEBIAN_FRONTEND=noninteractive

# Create a response to automate the installer
ubiquity --automatic \
  --no-bootloader \
  --allow-password-empty \
  --username=provisioner \
  --fullname="Provisioner" \
  --password=packer \
  --install-language=en_US

# After installation, setup SSH
mkdir -p /home/provisioner/.ssh
echo "ssh-rsa YOUR_SSH_PUBLIC_KEY_HERE" > /home/provisioner/.ssh/authorized_keys
chmod 700 /home/provisioner/.ssh
chmod 600 /home/provisioner/.ssh/authorized_keys
chown -R 1000:1000 /home/provisioner/.ssh
echo "provisioner ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/provisioner
chmod 440 /etc/sudoers.d/provisioner