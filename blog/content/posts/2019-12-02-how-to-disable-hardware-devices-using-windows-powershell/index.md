---
title: How to enable/disable hardware devices using Windows Powershell
author: Aiden Arnkels-Webb
#type: post
date: 2019-12-02T22:31:54+00:00
aliases: 
  - /how-to-disable-hardware-devices-using-windows-powershell/
cover:
    image: "cover.png" # image path/url
    alt: "Screenshot of Advanced NTFS Permissions" # alt text
    caption: "<text>" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
neve_meta_container:
  - default
neve_meta_sidebar:
  - default
neve_meta_disable_header:
  - off
neve_meta_disable_title:
  - off
neve_meta_disable_featured_image:
  - off
neve_meta_disable_footer:
  - off
neve_meta_enable_content_width:
  - off
neve_meta_content_width:
  - 70
categories:
  - Automation
tags:
  - Windows Server
  - PowerShell
  - Efficiency

---
If you're working on Windows Server Core or remotely on another computer and don't have access to the Windows GUI, you might have trouble disabling a faulty or unwanted plug-and-play device. Thankfully PowerShell makes it easy to get, enable and disable devices in Device Manager using [Get-PnpDevice][1], [Enable-PnpDevice][2] and [Disable-PnpDevice][3]

## **How to query devices**

```powershell
Get-PnpDevice # Get's all PNP Devices

Get-PnpDevice -PresentOnly # Gets all PNP Devices currently attached or physically present in the system

Get-PnpDevice -FriendlyName "*Ethernet*" # Gets all PNP Devices with a name containing "Ethernet"

Get-PnpDevice -Status ERROR # Gets all PNP Devices in an errored states
```

## **How to enable or disable devices**

To enable disable a device, simply pipe the output of Get-PnpDevice to Disable-PnpDevice or Enable-PnpDevice. Please be sure your Get-PnpDevice command is targeting the correct device before piping to avoid accidentally disabling devices you'd rather keep enabled!

```powershell
Get-PnpDevice -FriendlyName "*Ethernet*" | Disable-PnpDevice # Disables all PNP Devices with a name containing "Ethernet"

Get-PnpDevice -FriendlyName "*Ethernet*" | Enable-PnpDevice # Enables all PNP Devices with a name containing "Ethernet"
```

You could also output the instance ID to a variable for use later if you'd rather

```powershell
$DeviceID = Get-PnPDevice -FriendlyName "Intel(R) Ethernet Connection I217-V" | Select-Object InstanceID
Disable-PnpDevice -InstanceID $DeviceID
```

Or

```powershell
$DeviceID = (Get-PnpDevice -FriendlyName "Intel(R) Ethernet Connection I217-V").InstanceID
Disable-PnpDevice -InstanceID $DeviceID
```

 [1]: https://docs.microsoft.com/en-us/powershell/module/pnpdevice/get-pnpdevice?view=win10-ps
 [2]: https://docs.microsoft.com/en-us/powershell/module/pnpdevice/enable-pnpdevice?view=win10-ps
 [3]: https://docs.microsoft.com/en-us/powershell/module/pnpdevice/disable-pnpdevice?view=win10-ps
