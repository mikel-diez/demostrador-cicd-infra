#!/bin/bash
# NetBoot.xyz Docker Setup Script (TFTP only, no DHCP)
set -e  # Exit on error

# Configuration variables - ADJUST THESE TO MATCH YOUR NETWORK
LAN_SUBNET="192.199.1.0"  # Change to match your network

# Create directory structure in the current directory
mkdir -p config/tftpboot/{bios,efi32,efi64}
mkdir -p assets

# Create dnsmasq.conf for proxy DHCP mode in the current directory
cat > dnsmasq.conf << EOF
# dnsmasq configuration for netbootxyz
enable-tftp
tftp-root=/var/lib/tftpboot

# Proxy DHCP mode (doesn't assign IPs)
dhcp-range=$LAN_SUBNET,proxy

# Architecture detection
dhcp-vendorclass=BIOS,PXEClient:Arch:00000
dhcp-vendorclass=UEFI32,PXEClient:Arch:00006
dhcp-vendorclass=UEFI,PXEClient:Arch:00007
dhcp-vendorclass=UEFI64,PXEClient:Arch:00009

# Conditional boot files
dhcp-boot=net:UEFI32,efi32/netboot.xyz-i386.efi,bootserver,\${TFTP_SERVER_IP}
dhcp-boot=net:BIOS,bios/netboot.xyz.kpxe,bootserver,\${TFTP_SERVER_IP}
dhcp-boot=net:UEFI64,efi64/netboot.xyz.efi,bootserver,\${TFTP_SERVER_IP}
dhcp-boot=net:UEFI,efi64/netboot.xyz.efi,bootserver,\${TFTP_SERVER_IP}
EOF

# Download netboot files to their specific directories
cd config/tftpboot
# BIOS files
wget -P bios/ https://boot.netboot.xyz/ipxe/netboot.xyz.kpxe
wget -P bios/ https://boot.netboot.xyz/ipxe/netboot.xyz-undionly.kpxe

# UEFI files
wget -P efi64/ https://boot.netboot.xyz/ipxe/netboot.xyz.efi
wget -P efi32/ https://boot.netboot.xyz/ipxe/netboot.xyz-i386.efi

cd ../..

# Set proper permissions
chmod -R 755 .

echo "Starting containers..."
# Start the containers from the current directory
docker compose up -d

echo "NetBoot.xyz server setup complete."
echo "Web interface available at: http://localhost:3000"
echo "Management interface at: http://localhost:8080 (admin/admin)"