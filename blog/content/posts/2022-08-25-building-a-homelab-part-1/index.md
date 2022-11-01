---
title: "Building a Homelab Part 1"
date: 2022-08-25T12:43:03+01:00
draft: true
# weight: 1
# aliases: ["/first"]
tags: ["Homelab"]
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
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "Photo Credit: []()" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: true # only hide on current single page
#editPost:
#    URL: "https://github.com/Aidenwebb/aidenwebb-com-blog-code/content"
#    Text: "Suggest Changes" # edit text
#    appendFilePath: true # to append file path to Edit link
---

## Introduction

For the longest time, I've been running all manner of VM's and services on my own desktop PC. It can certainly handle it, with its Ryzen 3900X and 64GB RAM. It's served me very well and I have no complaints at all. However times change, new requirements emerge, and we adapt.

My partner is transitioning from a career as a vet to a career in software development. Quite the jump and an exciting and complicated time for her. (You can read about it on [her own blog, CatFromSpace](https://www.catfromspace.com/), if you like).

With this transiition, comes the likelihood that both of us will want use of some kind of lab environment for firing up a database, or self hosting some tool or service, and neither of us want to leave my PC on 24/7 to do so.

Now, I do have a QNAP 870 Pro NAS, which I upgraded the CPU and processor in a few months ago (I should probably write a blog post on that actually), but this is still relatively low spec running Xeon E31265L and 8GB DDR3 RAM. Enough for some basic containers, but liable to run out of memory quickly.

We've been considering buying an old Elitedesk G3, kitting it out with 32GB RAM, and running that as a little lab-box, but budgets are tight at the moment, we've had an expensive few months and we've been unsure if we wanted to spend £450~ on a mini-pc at this time.

## Behold! The LabTop

We do have a spare laptop. 8GB RAM, i7 processor, iffy graphics card, not a bad little machine, it's been running as a spare/mini lab for a little while, where I wipe and rebuild it ad-hoc to test bits and bobs. Conveniently, it doesn't have soldered-on RAM, and supports up to 2 32GB Sodimms. I reckon it'll make a perfectly adequate LabTop until such a time as we out-grow it.

First up, I ordered a [32GB Dimm](https://www.amazon.co.uk/gp/product/B07ZLC7VNH/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&psc=1) for £103, much cheaper than the £450 the kitted out Elitedesk would have come to. That should arrive in a couple of days. I should be able to run it either with 40GB (8GB + 32GB, provided there's no issues), or at the least with 32GB on the single DIMM, upgrading to 64GB at a later time. In either case, I can't see us capping out 32GB RAM too quickly, and if we do, we can order another stick. Additionally, we can always transfer those sticks to a mini PC at a later point if we decide that's a better option than a laptop running hot.

## Setting up

### The plan

At this early stage, I'm quite happy storing most of the data we might need on my NAS. The laptop has a 512GB SSD which should be plenty for running the base VM's and configs required, with data stores on the NAS.

1. Install Server 2022 and configure it
   1. Install Hyper-V and WSL
   2. Install Docker Desktop
2. Install Portainer on Docker
3. Install Pi-Hole using Portainer to handle DNS.
   1. Configure Pi-Hole  

### Installing Server 2022

1. A fairly straightforward, standard Windows installation. Click through the options etc.
2. Set the name of the system: LabTop
3. Created user accounts. One Admin for me, one Admin for my partner, and a dubious security decision to create a User "TV" account as we don't want to type in a long password when we want to use the laptop to watch something on TV.
4. Install Hyper-V through the Server Manager
5. Install the WSL Kernel [using the Manual download](https://docs.microsoft.com/en-us/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)
6. Reboot
7. Set the Static IP of the system now that its NIC is shared with Hyper-V. 
8. Install Ubuntu on WSL
   1. `wsl --install -d ubunut-20.04`
9. Install [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/)
10. Enable Remote Desktop access to Windows
11. Reboot

### Installing some other helpful tools

1. Install [Chocolatey](https://chocolatey.org/install)
    1. `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))`
2. Install Git
   1. `choco install git`
3. Install Python 3
   1. `choco install python3`

Everything's now set up and I can remotely connect to the laptop from my desktop.

### Installing and configuring Portainer

#### Installing Portainer - a very easy 2 step process

From CMD:

1. `docker volume create portainer_data`
2. `docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.9.3`

In browser:

1. Navigate to https://localhost:9443
2. Set your initial admin username and password

#### Configuring Portainer

I knew I wanted to use [SelfHostedPro]'s templates for containers/stacks such as Pi-Hole, so after logging in, the first thing I did was go to Portainer's settings and change the App Templates URL to `https://raw.githubusercontent.com/SelfhostedPro/selfhosted_templates/master/Template/portainer-v2.json`

#### Making it accessible

I created a firewall rule allowing access to TCP port 9443.

### Installing and configuring Pi-Hole

#### Installing Pi-Hole

In Portainer:

1. Click Volumes and create two new volumes
   1. `pihole-data-etc-pihole`
   2. `pihole-data-etc-dnsmasq.d`
2. Click App Templates, search for and click on Pi-Hole
   1. Name the container `pihole`
   2. Click `Show advanced options`
   3. Delete port 67, as I don't want to use Pi-Hole for DHCP
   4. Set mapping for `/etc/pihole` to Volume `pihole-data-etc-pihole`
   5. Set mapping for `/etc/dnsmasq.d` to Volume `pihole-data-etc-dnsmasq.d`
   6. Click `Deploy the container`
3. Click `Containers` in the left hand menu
   1. Click the logs icon next to pihole
   2. Disable Auto-refresh logs so you can scroll up
   3. Find the line `Assigning random password: ` and take note of the admin password
   4. Wait for the container to finish deploying


#### Configuring Pi-Hole

1. Log in to Pi-Hole by browsing to your host on port 1010
2. Log in with the randomly assigned password
3. Go to Group Management > Adlists and add any lists you want to add from [Firebog](https://firebog.net/)

#### Configuring Pi-Hole - Whitelisting the easy way

There is a big list of commonly whitelisted domains over at the [Pi-Hole forum](https://discourse.pi-hole.net/t/commonly-whitelisted-domains/212) but copy-pasting them all in to Pi-Hole is a lengthy, painful process.

Thankfully [anudeepND](https://github.com/anudeepND) has a [curated Whitelist](https://github.com/anudeepND/whitelist#for-whitelisttxt) with relatively simple deployment steps. Let's do this.

My Pi-Hole container doesn't include python3, so I'll need to deploy the Whitelist from outside the container. 

First we need to make the docker-desktop-data directory available to our WSL Ubuntu instance

1. Mount docker-desktop-data as a network drive in Windows (from a non Administrator CMD)
   1. `net use d: \\wsl$\docker-desktop-data`
2. Mount the Windows Network drive in Ubuntu WSL
   1. `sudo mkdir -p /mnt/wsl2/docker-desktop-data`
   2. `sudo mount -t drvfs d: /mnt/wsl2/docker-desktop-data`

Next we clone anudeepND's repository and run the script.

In WSL Ubuntu

1. `cd ~`
2. `mkdir anudeepND-whitelist`
3. `cd anudeepND-whitelist`
4. `git clone https://github.com/anudeepND/whitelist.git`
5. `cd whitelist/scripts`
6. `sudo python3 ./whitelist.py --dir /mnt/wsl2/docker-desktop-data/data/docker/volumes/pihole-data-etc-pihole/_data/ --docker`
7. Optionally add the referral list
   1. `sudo ./referral.sh --dir /mnt/wsl2/docker-desktop-data/data/docker/volumes/pihole-data-etc-pihole/_data/ --docker`