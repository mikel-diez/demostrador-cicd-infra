# NetbootXYZ with DNSMASQ

This setup provides a netboot environment with support for both UEFI and Legacy BIOS PXE boot.

## Components

- **NetbootXYZ**: Main service for network booting
- **DNSMASQ**: Handles architecture detection and conditional boot file serving

## Requirements

- Docker and Docker Compose
- Network with DHCP server (e.g., Mikrotik router)
- Port requirements:
  - 3000: Web interface
  - 69/udp: TFTP
  - 8080: Management interface

## Setup

1. Configure your network settings in `setup.sh`:
   ```bash
   LAN_SUBNET="192.199.1.0"  # Change to match your network
   ```

2. Run the setup script:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

3. Configure your DHCP server (e.g., Mikrotik) to point to this server's IP for network boot.

## Access

- Web interface: http://localhost:3000
- Management interface: http://localhost:8080 (admin/admin)

## Architecture Support

The setup automatically detects client architecture and serves appropriate boot files:
- BIOS Legacy PXE
- UEFI 32-bit
- UEFI 64-bit

## Notes

- The TFTP server serves files from the `assets` directory
- Configuration is persistent in the `config` directory
- DNSMASQ runs in network host mode to properly handle PXE requests 