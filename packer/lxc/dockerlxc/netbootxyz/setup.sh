#!/bin/bash
# NetBoot.xyz Docker Setup Script (TFTP only, no DHCP)

# Configuration variables - ADJUST THESE TO MATCH YOUR NETWORK
DOCKER_DIR="netboot-xyz"
LAN_SUBNET="192.199.1.0"  # Change to match your network

# Create directory structure
mkdir -p "$DOCKER_DIR/config/tftpboot"
mkdir -p "$DOCKER_DIR/assets"

# Create dnsmasq.conf for proxy DHCP mode
cat > "$DOCKER_DIR/dnsmasq.conf" << EOF
# Proxy DHCP mode (doesn't assign IPs)
dhcp-range=$LAN_SUBNET,proxy
pxe-service=x86PC,"Boot from network",netboot.xyz.kpxe
enable-tftp
tftp-root=/config/tftpboot

# Log settings
log-queries
EOF

# Download netboot files
cd "$DOCKER_DIR/config/tftpboot"
wget https://boot.netboot.xyz/ipxe/netboot.xyz.kpxe
wget https://boot.netboot.xyz/ipxe/netboot.xyz-undionly.kpxe
wget https://boot.netboot.xyz/ipxe/netboot.xyz.efi

# Set proper permissions
chmod -R 755 "$DOCKER_DIR"

# Start the containers
cd "$DOCKER_DIR"
docker compose up -d