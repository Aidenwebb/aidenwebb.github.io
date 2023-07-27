---
title: 'How to Fix Server 2019 Activation Error: Run “slui.exe 0x2a 0xC004F069”'
author: Aiden Arnkels-Webb
#type: post
date: 2021-03-09T13:17:55+00:00
#excerpt: "You're unable to activate a copy of Windows Server 2019 Evaluation edition with your VLSC MAK key. Server 2019 Evaluation edition can only be activated with a retail key. This must happen before a Volume Licence Key can be used. Read further to learn how to solve this problem"
aliases:
  - /how-to-fix-server-2019-activation-error-run-slui-exe-0x2a-0xc004f069/
cover:
    image: "cover.png" # image path/url
    alt: "" # alt text
    caption: "" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
tags: ["Windows", "Troubleshooting", "Windows Server", "Windows Server 2019", "Product Licencing", "IT & Tech"]
draft: false
---
## The Problem

You're unable to activate a copy of Windows Server 2019 Evaluation edition with your VLSC MAK key

## The Cause

Server 2019 Evaluation edition can only be activated with a retail key. This must happen before a Volume Licence Key can be used.

## The Fix

We need to use DISM to change the product version/edition

Open an elevated command prompt

1. Get a list of available version upgrade paths by typing:

      ```powershell
      DISM.exe /Online /Get-TargetEditions
      ```

2. Then upgrade to the listed edition by typing:

      ```powershell
      DISM /Online /Set-Edition:<TargetEdition> /ProductKey:<Product Key from Below Table> /AcceptEula
      ```

      EG: DISM /Online /Set-Edition:ServerDatacenterCor /ProductKey:XXXXX-XXXXX-XXXXX-XXXXX-XXXXX /AcceptEula

      |Server Edition|Product GVLK|
      |:----|:----|
      |Windows Server 2022 Datacenter|WX4NM-KYWYW-QJJR4-XV3QB-6VM33|
      |Windows Server 2022 Datacenter Azure Edition|NTBV8-9K7Q8-V27C6-M2BTV-KHMXV|
      |Windows Server 2022 Standard|VDYBN-27WPP-V4HQT-9VMD4-VMK7H|
      |Windows Server 2019 Datacenter|WMDGN-G9PQG-XVVXX-R3X43-63DFG|
      |Windows Server 2019 Standard|N69G4-B89J2-4G8F4-WWYCC-J464C|
      |Windows Server 2019 Essentials|WVDHN-86M7X-466P6-VHXV7-YY726|
      |Windows Server 2019 Azure Core|FDNH6-VW9RW-BXPJ7-4XTYG-239TB|
      |Windows Server 2019 Datacenter Semi-Annual Channel (v.1809)|6NMRW-2C8FM-D24W7-TQWMY-CWH2D|
      |Windows Server 2019 Standard Semi-Annual Channel (v.1809)|N2KJX-J94YW-TQVFB-DG9YT-724CC|
      |Windows Server 2019 ARM64|GRFBW-QNDC4-6QBHG-CCK3B-2PR88|
      |Windows Server 2016 Standard Semi-Annual Channel (v.1803)|PTXN8-JFHJM-4WC78-MPCBR-9W4KR|
      |Windows Server 2016 Datacenter Semi-Annual Channel (v.1803)|2HXDN-KRXHB-GPYC7-YCKFJ-7FVDG|
      |Windows Server 2016 Datacenter Semi-Annual Channel (v.1709)|6Y6KB-N82V8-D8CQV-23MJW-BWTG6|
      |Windows Server 2016 Standard Semi-Annual Channel (v.1709)|DPCNP-XQFKJ-BJF7R-FRC8D-GF6G4|
      |Windows Server 2016 ARM64|K9FYF-G6NCK-73M32-XMVPY-F9DRR|
      |Windows Server 2016 Datacenter|CB7KF-BWN84-R7R2Y-793K2-8XDDG|
      |Windows Server 2016 Standard|WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY|
      |Windows Server 2016 Essentials|JCKRF-N37P4-C2D82-9YXRT-4M63B|
      |Windows Server 2016 Cloud Storage|QN4C6-GBJD2-FB422-GHWJK-GJG2R|
      |Windows Server 2016 Azure Core|VP34G-4NPPG-79JTQ-864T4-R3MQX|

4. Reboot the system and enter your MAK key either via the GUI or by running the two commands

      ```powershell
      slmgr.vbs /ipk <Your Product Key>
      slmgr.vbs /ato
      ```
