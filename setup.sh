#!/bin/bash

# Create required directories
mkdir -p assets config

# Set proper permissions
chmod -R 755 assets config

# Create basic configuration
cat > config/config.yml << 'EOF'
tftp:
  enabled: true
  root: /assets
  timeout: 5000

http:
  enabled: true
  port: 80

https:
  enabled: true
  port: 443

boot:
  timeout: 5000
  uefi_timeout: 5000
  legacy_timeout: 5000
  menu_timeout: 5000

assets:
  - name: netboot.xyz
    url: https://boot.netboot.xyz
    path: /assets
EOF

# Pull the latest image
docker-compose pull

# Restart the service
docker-compose down
docker-compose up -d

# Wait for container to be ready
sleep 5

# Check if service is running
docker ps | grep netbootxyz

echo "Setup complete. Please ensure your DHCP server is configured with:"
echo "Next-Server: <this-server-ip>"
echo "Filename: netboot.xyz.efi (for UEFI) or netboot.xyz (for Legacy)" 