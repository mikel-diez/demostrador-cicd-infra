#!/bin/bash

# Create directories if they don't exist
mkdir -p grafana-data
mkdir -p influxdb-data

# Set permissions (use your actual user UID:GID instead of 1000:1000 if different)
chown -R 1000:1000 grafana-data
chown -R 1000:1000 influxdb-data

# Make the setup script executable
chmod +x setup.sh

echo "Directories created and permissions set."
echo "Run 'docker-compose up -d' to start the containers." 