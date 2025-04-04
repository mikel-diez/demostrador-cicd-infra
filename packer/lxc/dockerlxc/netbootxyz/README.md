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

## Cloud-Init Support

This installation supports cloud-init out of the box. To use it:

1. Boot your machine with PXE
2. In the netboot.xyz menu, select your desired distribution
3. Look for options like "Ubuntu 22.04 Cloud Image" or similar cloud-ready images
4. When prompted, you can:
   - Use a remote cloud-init config by providing its URL
   - Use a local config by placing your `user-data` file in `assets/cloud-init/` and using http://your-server:3000/cloud-init/user-data as the URL

Example workflow:
1. Create your cloud-init config:
   ```bash
   mkdir -p assets/cloud-init
   cat > assets/cloud-init/user-data << EOF
   #cloud-config
   hostname: my-server
   users:
     - name: admin
       sudo: ALL=(ALL) NOPASSWD:ALL
       ssh_authorized_keys:
         - ssh-rsa YOUR_KEY...
   EOF
   ```

2. Boot your machine and select a cloud image
3. Use http://your-server:3000/cloud-init/user-data as the config URL

## Notes

- The TFTP server serves files from the `assets` directory
- Configuration is persistent in the `config` directory
- DNSMASQ runs in network host mode to properly handle PXE requests
- A `.gitattributes` file with `* -text` is included to prevent git from tracking permission changes and line ending modifications 