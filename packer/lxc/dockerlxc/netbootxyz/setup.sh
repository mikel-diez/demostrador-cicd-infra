#!/bin/bash
# NetBoot.xyz Docker Setup Script (TFTP only, no DHCP)
set -e  # Exit on error

# Configuration variables - ADJUST THESE TO MATCH YOUR NETWORK
LAN_SUBNET="192.199.1.0"  # Change to match your network

# Create directory structure in the current directory
mkdir -p config
mkdir -p assets

# Create dnsmasq.conf for proxy DHCP mode in the current directory
cat > dnsmasq.conf << EOF
# dnsmasq configuration for netbootxyz
enable-tftp
tftp-root=/var/lib/tftpboot

# Proxy DHCP mode (doesn't assign IPs)
dhcp-range=$LAN_SUBNET,proxy

# UEFI Boot configuration
dhcp-match=set:efi-x86_64,option:client-arch,7
dhcp-match=set:efi-x86_64,option:client-arch,9
dhcp-match=set:efi-x86,option:client-arch,6
dhcp-boot=tag:efi-x86_64,netboot.xyz.efi
dhcp-boot=tag:efi-x86,netboot.xyz.efi

# Legacy BIOS Boot configuration
dhcp-match=set:bios,option:client-arch,0
dhcp-boot=tag:bios,netboot.xyz.kpxe

# PXE menu entries
pxe-service=X86PC, "Boot BIOS PXE", netboot.xyz.kpxe
pxe-service=BC_EFI, "Boot UEFI iPXE", netboot.xyz.efi
pxe-service=X86-64_EFI, "Boot UEFI iPXE", netboot.xyz.efi
EOF

# Download netboot files
cd assets
wget https://boot.netboot.xyz/ipxe/netboot.xyz.efi
wget https://boot.netboot.xyz/ipxe/netboot.xyz.kpxe
cd ..

# Set proper permissions
chmod -R 755 .

echo "Starting containers..."
docker compose down
docker compose up -d

echo "NetBoot.xyz server setup complete."
echo "Web interface available at: http://localhost:3000"