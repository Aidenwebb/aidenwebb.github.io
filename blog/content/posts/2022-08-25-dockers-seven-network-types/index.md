---
title: "Dockers seven network types and when to use them"
date: 2022-08-25T12:40:30+01:00
draft: false
# weight: 1
# aliases: ["/first"]
categories:
  - Architecture
tags: 
  - Docker
  - Networking
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
    image: "cover.png" # image path/url
    alt: "Docker logo" # alt text
    #caption: "Photo Credit: []()" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
#editPost:
#    URL: "https://github.com/Aidenwebb/aidenwebb-com-blog-code/content"
#    Text: "Suggest Changes" # edit text
#    appendFilePath: true # to append file path to Edit link
---

## 1. The Default Bridge

This is the default network that new containers will connect to. It's a software bridge between your docker instance and your host system, providing isolation between the bridge network and other networks, including the host network and other bridge networks on the host. Docker best practices discourage using this network for containers, recommending User-Defined bridges instead, which we will get to in #4.

**When to use it:** Avoid using the Default Bridge, use another network type instead where possible

## 2. The Default Host

The host network mode is just that, containers are connected directly to the same network as the host. Containers are not isolated from the network or the host in this mode. The host and the container share all their open ports and network configurations. The container runs as though it was an application on the host.

The host network mode Linux only and is not supported on Windows or Mac.

**When to use it:** Handy when a container needs to expose a large number of ports, or the container runs an application that you would like to act as if running natively. Useful for things like VPN servers for example

## 3. The Default None

Does what it says on the tin, the container is not connected to any network.

**When to use it:** When you don't want a container to be connected to a network at all. Useful for complete network isolation for containers that don't need network access. Containers exclusively operating on files on a volume such as producing backups, artifacts, or auditing for example.

## 4. The User Defined Bridge

User defined bridges are just like the default bridge, except they come with a number of perks.

### Automated DNS resolution

Containers within a user-defined bridge are able to automatically resolve eachother by their container name or alias. Containers on the default bridge network can only resolve eachother by their IP addresses unless you use the legacy `--link` option.
In a situation where you have a `web` and `db` container in a user-defined bridge network, the `web` container can connect to the `db` container simply by connecting to the `db` host name, no matter which Docker host the application stack is running on.
This is especially useful as containers IP addresses may often change when redeployed.

### Better isolation

All containers without the `--network` flag defined are by default attached the the default bridge network, which can be risky as unrelated stacks, services and containers are able to communicate.

### On-the-fly attachment and detachment

Containers can be connected or disconnected from user-defined networks while running. In order to connect or remove a container from the default bridge, the container must be stopped and recreated.

### Congigurable network settings

User-defined bridges can be configured with different/non-standard network settings, like changing the MTU or iptables rules.

You can create a new user-defined bridge network by running
`docker network create <network-name>`.

**When to use it:** Most of the time, you will want to create your containers in their own user-defined networks. Running a stack of applications in a user-defined network for that stack enables each container in the stack to talk to each other, but without exposing the containers to anything more than necessary. A stack containing a `web` and `db` container might expose port `80` to the web, but keep the database completely isolated.

## 5. The Overlay Network

A distributed network that can be shared among multiple Docker hosts. It sits on top of the host=specific networks and allows contaienrs connected to it to communicate with eachother. Docker handles the routing of packets to and from their respective hosts and containers. This is not supported by Windows nodes.

**When to use it:** When you have a large number of docker hosts in a swarm, and want them to be able to communicate with eachother at a greater level of abstraction.

## 6. The MACVLAN

### Bridge Mode

MACVLAN networks are bound directly to the physical port on the host, and configured to communicate directly to the physical networks. Containers have their own MAC addresses and IP addresses, similar to as though they were virtual machines.
Some networks will not allow multiple MAC addresses to be available on one Switch port, and so Promiscuous mode must be enabled on each device between the host and the router.

Containers in a MACVLAN must be manually assigned their own IP addresses as they won't get DHCP addresses from the router. This is because Docker will apply its own DHCP addresses to the container.

This can be created by running: `docker network create -d macvlan --subnet 10.1.2.0/24 --gateway 10.1.2.1 -o parent=<physical-host-NIC> <network-name>`

**When to use it:** When you want your containers to act as though they're physical devices on the same network as your router, and avoid the abstraction layers of Docker and the host. Could be useful for applications that require Layer 2 networking or their own MAC addresses to operate.

### 801.1q Mode

Works just like the Bridge Mode, but can also be configured with VLANs as sub-interfaces.

This can be created by running: `docker network create -d macvlan --subnet 10.1.2.0/24 --gateway 10.1.2.1 -o parent=<physical-host-NIC>.50 <network-name>`

**When to use it:** When you want your containers to also be VLAN aware

## 7. The IPVLAN

Works similarly to MACVLAN but with the difference of all containers within using the same MAC address as the host interface. This means we don't need to fight with Promiscuous mode. Works similarly to the HOST mode, but can specify a second host interface. IPVLAN also support VLAN sub-interfaces.

This can be created by running: `docker network create -d ipvlan --subnet 10.1.2.0/24 --gateway 10.1.2.1 -o parent=<physical-host-NIC> <network-name>`

**When to use it:** When you want your containers to act as though they're on the same network as your router, but do not require their own MAC addresses.

### IPVLAN L3 Mode

Adds Layer 3 routing to the network mode. This means no switches, no ARP, and no broadcast/multicast traffic coming out of the host. The host then acts as a router.

This can be created by running: `docker network create -d ipvlan --subnet 10.1.2.0/24 --gateway 10.1.2.1 -o ipvlan_mode=l3 <network-name>`

**When to use it:** When you the host to act as a router for containers in the network, stopping broadcast traffic from containers from reaching the network the host is attached to.