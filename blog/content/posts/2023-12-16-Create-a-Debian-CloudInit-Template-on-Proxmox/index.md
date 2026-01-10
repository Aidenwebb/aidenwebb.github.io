---
title: "Create a Debian Cloud-init Template on Proxmox"
date: 2023-12-16T13:46:03Z
draft: false
# weight: 1
# aliases: ["/first"]
categories:
- Infrastructure & Architecture
- Resources & Guides
tags: 
- Proxmox
- Efficiency
- Scalability
author: "Aiden Arnkels-Webb"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: false
hidemeta: false
#comments: false
#description: "Desc Text."
#canonicalURL: "https://canonical.url/to/page"
disableHLJS: true # to disable highlightjs
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "images/cover.webp" # image path/url
    alt: "Digital artwork depicting the concept of Cloud-init technology in a hypervisor environment. The image features a central, stylized cloud with intricate digital circuit patterns, symbolizing Cloud-init. Surrounding the cloud are interconnected, floating, semi-transparent cubes with glowing edges, each representing a hypervisor. Faint streams of binary code flow between these cubes, illustrating virtualization and connectivity. The background is a gradient of blue shades, representing technology and innovation, with subtle abstract digital patterns enhancing the futuristic theme." # alt text
    # caption: "Image Credit: Generated with DALL-E" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
#editPost:
#    URL: "https://github.com/Aidenwebb/aidenwebb-com-blog-code/content"
#    Text: "Suggest Changes" # edit text
#    appendFilePath: true # to append file path to Edit link
---

Cloud-init is the industry standard multi-distribution method for cross-platform cloud instance initialization. It is supported across all major public cloud providers, provisioning systems for private cloud infrastructure, and bare-metal installations.

Using Proxmox templates in tandem with Cloud-init streamlines the process of launching new VMs. With this approach, a template can rapidly generate a new VM, and Cloud-init takes care of the initial setup during boot, reducing your tasks to simply setting up the hostname and initial user account. This eliminates the need for manually configuring a fresh operating system installation for each VM. This guide focuses on creating a template Debian configuration.

Although Debian doesn't offer a dedicated image specifically for this scenario, the Debian images intended for OpenStack/Cloud are equipped with Cloud-init compatibility. For more information on how Proxmox supports Cloud-Init, refer to [Proxmox's documentation][proxmox-docs].

Assuming you're a beginner, running through this guide to get a template set up and configured should take you approximately 10 minutes. Diving a bit deeper in to each of the commands will take longer to understand what's happening behind the scenes. It can be useful to have the Proxmox web interface open as you proceed through each step so you can see how the changes after each command are reflected in the web interfac.

Good luck and happy hacking!

## Download the Cloud-init image

Download the latest `genericcloud` image from the [Debian Official Cloud Images Repository](https://cloud.debian.org/images/cloud/) directly on to the Proxmox host

### Debian 11

```bash
wget https://cloud.debian.org/images/cloud/bullseye/20231004-1523/debian-11-genericcloud-amd64-20231004-1523.qcow2
```

### Debian 12

```bash
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2
```

## Create a new VM using the image

```bash
# Set the VM ID to operate on
VMID=9001
# Choose a name for the VM
TEMPLATE_NAME=Debian12CloudInit
# Choose the disk image to import
DISKIMAGE=debian-12-genericcloud-amd64.qcow2
# Select Host disk
HOST_DISK=local-zfs

# Create the VM
qm create $VMID --name $TEMPLATE_NAME --net0 virtio,bridge=vmbr0
# Set the OSType to Linux Kernel 6.x
qm set $VMID --ostype l26
# Import the disk
qm importdisk $VMID $DISKIMAGE $HOST_DISK
# Attach disk to scsi bus
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $HOST_DISK:vm-$VMID-disk-0
# Set scsi disk as boot device
qm set $VMID --boot c --bootdisk scsi0
# Create and attach cloudinit drive
qm set $VMID --ide2 $HOST_DISK:cloudinit
# Set serial console, which is needed by OpenStack/Proxmox
qm set $VMID --serial0 socket --vga serial0
# Enable Qemu Guest Agent
qm set $VMID --agent enabled=1 # optional but recommened
```

## Configure other VM options to suite needs

```bash
# Start the VM at boot
qm set $VMID --onboot 1
```

## Convert the VM into a template  

```bash
qm template $VMID
```

## Create a new VM from the template  

```bash
# Set a variable for our new VM ID
NEW_VMID=2001
NEW_VM_NAME=MyNewServer
qm clone $VMID $NEW_VMID --name $NEW_VM_NAME --full
```

## Configure the VM

Once the VM is created, there are some common adjustments we might want to make, such as assigning additional vCPUs, RAM, or disk space.

```bash
# Show Current configs
qm config $NEW_VMID

# Allocate 2GB of RAM
qm set $NEW_VMID --memory 2048
# Allocate 2 vCPU Cores
qm set $NEW_VMID --cores 2
# Resize bootdisk
## Get bootdisk interface
NEW_VM_BOOTDISK_INTERFACE=$(qm config $NEW_VMID | grep bootdisk | awk '{print $2}')
## Resize bootdisk to 32GB
qm disk resize $NEW_VMID $NEW_VM_BOOTDISK_INTERFACE 32G

```

## Configure Cloud-init

```bash
# Set Network config
## Static
qm set $NEW_VMID --ipconfig0 ip=172.17.1.132/24,gw=172.17.1.1
## DHCP
qm set $NEW_VMID --ipconfig0 ip=dhcp

# Set Username
qm set $NEW_VMID --ciuser aiden

# Setup public SSH keys (one key per line, OpenSSH format).
qm set $NEW_VMID --sshkeys ~/vm_sshkeys/keylist

```

## Boot and initialise the VM  

```bash
sudo apt update
sudo apt upgrade

# Install and enable QEMU guest agent
sudo apt install qemu-guest-agent
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent

```

## References

- [Proxmox PVE Documentation][proxmox-docs]
- [Cloud-init Github][cloud-init-github]

[proxmox-docs]: https://pve.proxmox.com/pve-docs/qm.1.html
[cloud-init-github]: https://github.com/canonical/cloud-init
