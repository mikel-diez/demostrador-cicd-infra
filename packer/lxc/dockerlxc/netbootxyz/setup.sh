#!/bin/bash
# NetBoot.xyz Docker Setup Script (TFTP only, no DHCP)
set -e  # Exit on error

# Configuration variables - ADJUST THESE TO MATCH YOUR NETWORK
LAN_SUBNET="192.199.1.0"  # Change to match your network

# Create directory structure in the current directory
mkdir -p config/tftpboot
mkdir -p assets

# Create dnsmasq.conf for proxy DHCP mode in the current directory
cat > dnsmasq.conf << EOF
# dnsmasq configuration for netbootxyz
enable-tftp
tftp-root=/var/lib/tftpboot

# Proxy DHCP mode (doesn't assign IPs)
dhcp-range=$LAN_SUBNET,proxy

# Simple boot configuration
dhcp-boot=netboot.xyz.efi
pxe-service=X86PC, "Boot UEFI iPXE", netboot.xyz.efi
pxe-service=BC_EFI, "Boot UEFI iPXE", netboot.xyz.efi
pxe-service=X86-64_EFI, "Boot UEFI iPXE", netboot.xyz.efi
EOF

# Download netboot files
cd config/tftpboot
wget https://boot.netboot.xyz/ipxe/netboot.xyz.efi
wget https://boot.netboot.xyz/ipxe/netboot.xyz.kpxe
cd ../..

# Set proper permissions
chmod -R 755 .

echo "Starting containers..."
docker compose down
docker compose up -d

echo "NetBoot.xyz server setup complete."
echo "Web interface available at: http://localhost:3000"