#!/bin/bash

# Install git
sudo apt-get update
sudo apt-get install -y git
sudo apt-get install -y gnupg2
sudo apt-get install -y software-properties-common

# Install Hashicorp Packer
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install -y packer
packer plugins install github.com/hashicorp/proxmox

# Verify installations
git --version
packer --version
