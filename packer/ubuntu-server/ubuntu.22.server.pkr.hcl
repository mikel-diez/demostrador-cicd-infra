# get from enviroment
variable "proxmox_url" {
    type    = string
    default = env("PACKER_PROXMOX_URL")
}

variable "proxmox_api_token_id" {
    type    = string
    default = env("PACKER_PROXMOX_API_TOKEN_ID")
}

variable "proxmox_api_secret" {
    type       = string
    sensitive  = true
    default    = env("PACKER_PROXMOX_API_SECRET")
}



source "proxmox-iso" "ubuntu-server-focal"  {
    proxmox_url = var.proxmox_url
    username    = var.proxmox_api_token_id
    token       = var.proxmox_api_secret
    insecure_skip_tls_verify = true 

    node                 = "pve-node-1"
    vm_id                = 700
    vm_name              = "ubuntu2204server"
    template_description = "Ubuntu server 22.04 template"


    # download the image from https://releases.ubuntu.com/jammy/ via UI 
    # then move it to a storage in Proxmox
    boot_iso {
        type             = "ide"
        iso_file         = "local:iso/ubuntu-22.04.5-live-server-amd64.iso"
        unmount          = true
    }

    # system settings
    iso_storage_pool = "local"
    unmount_iso = true
    qemu_agent = true  # lets prmoxmox agent to retrieve machine data to show in IU, as 'vmware tools' in Vmware
    scsi_controller = "virtio-scsi-pci" # default controller in most cases

    # hard disk os VM
    disks {
        disk_size = "20G"
        format = "raw"
        storage_pool = "local-lvm"
        storage_pool_type = "lvm"
        type = "virtio"
    }

    # cpu
    cores = 2
    #threads = 2
    sockets = 2
    # memory
    memory = 4096

    # network
    network_adapters {
        model    = "virtio"
        bridge   = "vmbr0"
        firewall = false
    }

    # clout-init settings, here to store the cloud-init files
    cloud_init              = true
    cloud_init_storage_pool = "local-lvm"


    boot_command = [
        "<esc><wait>",
        "e<wait>",
        "<down><down><down><end>",
        "<bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
        "<f10><wait>"
    ]

    boot      = "c" # console mode for booting
    boot_wait = "5s" # wait time



    # directory where machine configuration exists
    http_directory = "cloud-init"

    # ssh settings 
    ssh_private_key_file = "/home/provisioner/.ssh/id_rsa"
    ssh_username = "provisioner"

    ssh_timeout  = "60m" # in my case takes quite loong time, but dependes on your network and hypervisor strength

    # packer binding, in case you want to expose packer in all netwokr interfaces and in an exact ports, if not just comment this 
    # in my case, I want to expose on all networks and in the port 80
    http_bind_address = "0.0.0.0"
    http_port_min = 4444
    http_port_max = 4444
}

# this is where the machine image is build
build {
    name    = "ubuntu2204server"  # name of the template that will be created in Proxmox
    sources = ["source.proxmox-iso.ubuntu-server-focal"] 

    # first shell script to be executed on the amchine
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo rm -f /etc/netplan/00-installer-config.yaml",
            "sudo sync"
        ]
    }
    
    # needed default files for cloud init
    provisioner "file" {
        source      = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }
    
    # needed default files for cloud init
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }

    # default packages widely used you can add here mosr scripts 
    provisioner "shell" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y htop tree",
            "sudo apt-get autoremove -y --purge",
            "sudo apt-get clean",
            "sudo apt-get autoclean",
            "sudo sync"
        ]
    }
}