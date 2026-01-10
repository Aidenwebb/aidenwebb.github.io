---
title: "How to Mount a qcow2 Disk Image"
date: 2023-06-02T14:13:55Z
draft: false
# weight: 1
# aliases: ["/first"]
categories:
  - Operations & Troubleshooting
  - Resources & Guides
tags:
  - Disaster Recovery
  - Proxmox
  - Debian Linux
  - Storage
author: "Aiden Arnkels-Webb"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: false
hidemeta: false
#comments: false
#description: "Desc Text."
#canonicalURL: "https://canonical.url/to/page"
disableHLJS: false # to disable highlightjs
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
    image: "images/cover.png" # image path/url
    alt: "Terminal showing commands to mount a qcow2 image" # alt text
    caption: "Photo Credit: [Aiden Arnkels-Webb](https://aidenwebb.com)" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
#editPost:
#    URL: "https://github.com/Aidenwebb/aidenwebb-com-blog-code/content"
#    Text: "Suggest Changes" # edit text
#    appendFilePath: true # to append file path to Edit link
---

Here's a streamlined guide on how to mount a qcow2 disk image on your host server/system, which can come in handy for tasks like resetting passwords, editing files, or recovering data without needing to run the virtual machine.

## Step 1 - Activating NBD on the Host

In your terminal, run the following command to enable NBD (Network Block Device) on your host (with sudo if required):

```bash
modprobe nbd max_part=8
```

## Step 2 - Link the QCOW2 to Network Block Device

Next, connect the QCOW2 disk image to the network block device using the following command:

```bash
qemu-nbd --connect=/dev/nbd0 /var/lib/vz/images/100/vm-100-disk-1.qcow2
```

## Step 3 - Identify the Virtual Machine Partitions

You can find the partitions of the virtual machine by running the following command:

```bash
fdisk /dev/nbd0 -l
```

## Step 4 - Access the Virtual Machine Partition

Now, to mount the partition from the virtual machine, you can use the following command:

```bash
mount /dev/nbd0p1 /mnt/my-mountpoint/
```

## Step 5 - Wrapping Up: Unmount and Disconnect

Once you've finished with the tasks, it's crucial to unmount and disconnect appropriately. Use the following commands to do so:

```bash
umount /mnt/somepoint/
qemu-nbd --disconnect /dev/nbd0
rmmod nbd
```
This will effectively close off your session.