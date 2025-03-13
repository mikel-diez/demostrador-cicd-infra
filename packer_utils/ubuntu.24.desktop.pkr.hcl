boot_command = [
    "<esc><wait>",
    "<enter><wait>",
    "/casper/vmlinuz<wait>",
    " root=LABEL=Ubuntu-Server<wait>",
    " initrd=/casper/initrd<wait>",
    " quiet<wait>",
    " autoinstall<wait>",
    " ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/<wait>",
    " ---<wait>",
    "<enter><wait>"
]

boot      = "c" # console mode for booting
boot_wait = "60s" # wait time

# directory where machine configuration exists
http_directory = "machine_config" 