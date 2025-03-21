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
# Proxy DHCP mode (doesn't assign IPs)
dhcp-range=$LAN_SUBNET,proxy
pxe-service=x86PC,"Boot from network",netboot.xyz.kpxe
enable-tftp
tftp-root=/config/tftpboot

# Log settings
log-queries
EOF

# Download netboot files to the current directory's config/tftpboot folder
cd config/tftpboot
wget https://boot.netboot.xyz/ipxe/netboot.xyz.kpxe
wget https://boot.netboot.xyz/ipxe/netboot.xyz-undionly.kpxe
wget https://boot.netboot.xyz/ipxe/netboot.xyz.efi
cd ../..

# Set proper permissions
chmod -R 755 .

echo "Starting containers..."
# Start the containers from the current directory
docker compose up -d

echo "NetBoot.xyz server setup complete."
echo "Web interface available at: http://localhost:3000"
echo "Management interface at: http://localhost:8080 (admin/admin)"