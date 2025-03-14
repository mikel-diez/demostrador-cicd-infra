#!/bin/bash

# Install git
sudo apt-get update
sudo apt-get install -y git

# Install Hashicorp Packer
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install -y packer

# Verify installations
git --version
packer --version
