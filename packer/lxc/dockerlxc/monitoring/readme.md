# Proxmox Monitoring Stack

This Docker Compose setup provides a complete monitoring solution for Proxmox using:

- **InfluxDB 2.x**: Time-series database with built-in web UI
- **Telegraf**: Agent that collects metrics from Proxmox API
- **Grafana**: Visualization and dashboards

## Setup

1. Copy `.env.template` to `.env` and update with your Proxmox API credentials:
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

## Accessing the Services

- **Grafana**: http://your-lxc-ip:3001 (default login: admin/admin)
- **InfluxDB UI**: http://your-lxc-ip:8086 (default login: admin/adminadmin12345)

## Important Notes

1. **InfluxDB 2.x** includes a built-in web UI at port 8086 with dashboarding and data exploration capabilities.

2. When accessing InfluxDB for the first time:
   - The initial setup is handled automatically via environment variables
   - Use the credentials defined in your `.env` file
   - Default: Username: admin, Password: adminadmin12345

3. The Telegraf agent is configured to:
   - Use the InfluxDB v2 API
   - Connect to your Proxmox server with API token authentication
   - Collect various system metrics

## Configuring Grafana with InfluxDB 2.x

1. In Grafana, go to Configuration > Data Sources > Add data source
2. Select "InfluxDB"
3. Set the URL to "http://influxdb:8086"
4. For InfluxDB Details:
   - Query Language: Flux
   - Organization: proxmox (or the value of INFLUXDB_ORG in your .env)
   - Token: your-token (from INFLUXDB_TOKEN in your .env)
   - Default Bucket: proxmox (or the value of INFLUXDB_BUCKET in your .env)

## Troubleshooting

If containers fail to start or you encounter permission issues:
1. Check container logs: `docker-compose logs`
2. Run the setup script again: `./setup.sh`
3. Ensure your Proxmox API token has correct permissions
4. For InfluxDB 2.x, make sure your admin password is at least 8 characters long 