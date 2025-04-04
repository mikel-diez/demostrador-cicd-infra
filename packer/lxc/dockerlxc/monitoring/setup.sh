#!/bin/bash

# Create directories if they don't exist
mkdir -p grafana-data
mkdir -p influxdb-data
mkdir -p influxdb-config

# Set permissions (use your actual user UID:GID instead of 1000:1000 if different)
chown -R 1000:1000 grafana-data
chown -R 1000:1000 influxdb-data
chown -R 1000:1000 influxdb-config

echo "Directories created and permissions set."
echo "Run 'docker-compose up -d' to start the containers."
echo ""
echo "=== PROXMOX CONFIGURATION INSTRUCTIONS ==="
echo "To configure your Proxmox server to send metrics to Telegraf:"
echo ""
echo "1. SSH into your Proxmox host"
echo "2. Edit the status configuration file:"
echo "   nano /etc/pve/status.cfg"
echo ""
echo "3. Add the following content (adjust IP address to your Telegraf container's IP):"
echo "   influxdb: influx1"
echo "     server YOUR_TELEGRAF_CONTAINER_IP"
echo "     port 8089"
echo ""
echo "4. Restart the Proxmox service:"
echo "   systemctl restart pvestatd"
echo ""
echo "Note: The indentation in the status.cfg file is important. Make sure to use spaces, not tabs."