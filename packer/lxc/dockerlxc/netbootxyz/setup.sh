#!/bin/bash
#!/bin/bash
# NetBoot.xyz Docker Setup Script

# Configuration variables - ADJUST THESE TO MATCH YOUR NETWORK
DOCKER_DIR="/opt/netboot-xyz"
DHCP_RANGE="192.168.1.100,192.168.1.200,255.255.255.0,12h"
ROUTER_IP="192.168.1.1"
DNS_SERVER="192.168.1.1"
DOMAIN_NAME="local"

# Create directory structure
mkdir -p "$DOCKER_DIR/config/tftpboot"
mkdir -p "$DOCKER_DIR/assets"

# Create dnsmasq.conf
cat > "$DOCKER_DIR/dnsmasq.conf" << EOF
# DHCP server configuration
dhcp-range=$DHCP_RANGE
dhcp-option=option:router,$ROUTER_IP
dhcp-option=option:dns-server,$DNS_SERVER
dhcp-option=option:domain-name,$DOMAIN_NAME

# PXE booting
dhcp-boot=netboot.xyz.kpxe
enable-tftp
tftp-root=/config/tftpboot

# Log settings
log-queries
log-dhcp
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