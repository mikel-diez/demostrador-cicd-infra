# Proxmox Monitoring Stack

This Docker Compose setup provides a monitoring solution for Proxmox using:

- **InfluxDB 2.x**: Modern time-series database with built-in web UI
- **Telegraf**: Agent that receives metrics from Proxmox via UDP and forwards to InfluxDB 2.x
- **Grafana**: Visualization and dashboards

## Setup

1. Copy `.env.template` to `.env` and update with your credentials:
   ```bash
   cp .env.template .env
   nano .env
   ```

2. Run the setup script to create necessary directories with proper permissions:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

3. Start the monitoring stack:
   ```bash
   docker-compose up -d
   ```

4. Follow the Proxmox configuration instructions displayed by the setup script to configure your Proxmox host to send metrics to Telegraf.

## Configuring Proxmox

To send metrics from your Proxmox host to Telegraf:

1. SSH into your Proxmox host
2. Edit the status configuration file:
   ```bash
   nano /etc/pve/status.cfg
   ```

3. Add the following content (using your actual Telegraf container IP):
   ```
   influxdb: influx1
     server YOUR_TELEGRAF_CONTAINER_IP
     port 8089
   ```

4. Restart the Proxmox service:
   ```bash
   systemctl restart pvestatd
   ```

Note: The indentation in the status.cfg file is important. Make sure to use spaces, not tabs.

## How It Works

1. Proxmox sends metrics in InfluxDB line protocol format to Telegraf via UDP (port 8089)
2. Telegraf receives these metrics and forwards them to InfluxDB 2.x
3. InfluxDB 2.x stores the metrics in the specified bucket
4. Grafana visualizes the data from InfluxDB 2.x

## Accessing the Services

- **Grafana**: http://your-lxc-ip:3001 (default login: admin/admin)
- **InfluxDB UI**: http://your-lxc-ip:8086 (default login: admin/adminadmin12345)

## Configuring InfluxDB as a Data Source in Grafana

1. In Grafana, go to Configuration → Data Sources → Add data source
2. Select "InfluxDB"
3. For InfluxDB 2.x:
   - URL: http://influxdb:8086
   - Authentication: None (internal network)
   - Query Language: Flux
   - Organization: proxmox (or the value from your .env)
   - Token: my-super-secret-admin-token (from your .env)
   - Default Bucket: proxmox
4. Click "Save & Test"

## Troubleshooting

If containers fail to start or you encounter permission issues:
1. Check container logs: `docker-compose logs`
2. Run the setup script again: `./setup.sh`
3. Verify the Proxmox configuration in `/etc/pve/status.cfg`
4. Check Telegraf logs for UDP packet reception: `docker-compose logs telegraf`
5. Make sure the Telegraf container is properly receiving UDP packets on port 8089
6. For InfluxDB 2.x, make sure your admin password is at least 8 characters long 