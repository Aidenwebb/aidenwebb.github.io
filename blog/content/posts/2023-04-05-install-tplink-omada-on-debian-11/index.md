---
title: "Install Tplink Omada on Debian 11"
date: 2023-04-05T17:44:11+01:00
draft: false
# weight: 1
# aliases: ["/first"]
categories:
  - Operations & Troubleshooting
  - Resources & Guides
tags:
  - Networking
  - Debian Linux
  - How-To
  - Tutorial
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
    image: "images/cover.jpg" # image path/url
    alt: "tp-link | Omada logo" # alt text
    caption: "Photo Credit: [tp-link Norway blog](https://www.tp-link.com/no/blog/1183/tp-link-ranks-first-in-the-shipment-share-of-small-business-wlan-access-points-market-in-1q22-in-the-gartner%C2%AE-report/)" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
#editPost:
#    URL: "https://github.com/Aidenwebb/aidenwebb-com-blog-code/content"
#    Text: "Suggest Changes" # edit text
#    appendFilePath: true # to append file path to Edit link
---

This guide covers installation of TP-Link's Omada Software Controller on Debian 11.

At the time of writing, Omada Controller version is 5.9.31.

## Update and Upgrade system

```bash
apt update && apt upgrade -y
```

## Install omada dependencies

```bash
apt install -y openjdk-11-jdk-headless curl autoconf make gcc
```

## Install MongoDB

Go to [Mongo DB's repository](https://repo.mongodb.org/apt/debian/dists/buster/mongodb-org/4.4/main/binary-amd64/) and select an appropriate server version. I'm using [MongoDb Server 4.4.16](https://repo.mongodb.org/apt/debian/dists/buster/mongodb-org/4.4/main/binary-amd64/mongodb-org-server_4.4.16_amd64.deb)

```bash
wget https://repo.mongodb.org/apt/debian/dists/buster/mongodb-org/4.4/main/binary-amd64/mongodb-org-server_4.4.16_amd64.deb
apt install -y ./mongodb-org-server_4.4.16_amd64.deb
```

## Compile and install jsvc

Go to [Apache Commons Daemon repo](https://dlcdn.apache.org/commons/daemon/source/) and select an appropriate commons version. As of writing, the latest version is 1.3.3 so that's what I'll use.

```bash
mkdir -p /opt/tplink-sources && cd /opt/tplink-sources

wget -c https://dlcdn.apache.org/commons/daemon/source/commons-daemon-1.3.3-src.tar.gz -O - | tar -xz

cd commons-daemon-1.3.3-src/src/native/unix

sh support/buildconf.sh

./configure --with-java=/usr/lib/jvm/java-11-openjdk-amd64

make

ln -s /opt/tplink-sources/commons-daemon-1.3.3-src/src/native/unix/jsvc /usr/bin/
```

## Download and install Omada Controller

```bash
cd /opt/tplink-sources
wget https://static.tp-link.com/upload/software/2023/202303/20230321/Omada_SDN_Controller_v5.9.31_Linux_x64.deb
dpkg --ignore-depends=jsvc -i ./Omada_SDN_Controller_v5.9.31_Linux_x64.deb
```
