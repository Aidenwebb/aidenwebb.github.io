---
title: How to check if your CPU supports Virtualisation
author: Aiden Arnkels-Webb
#type: post
date: 2020-08-26T13:42:09+00:00
aliases:
  - /how-to-check-if-your-cpu-supports-virtualisation/
cover:
    image: "cover.png" # image path/url
    alt: "Task Manager > Performance > CPU > Virtualisation" # alt text
    caption: "<text>" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
neve_meta_enable_content_width:
  - off
categories: 
  - Operations & Troubleshooting
tags:
  - Virtualization
  - Hyper-V
  - Windows OS
  - Quick-Fix
  - Reference Guide

---
## Check Task Manager

  1. The first, simplest option to check is to open task manager.
  2. Click the performance tab
  3. Check if Virtualisation is Enabled

  If Virtualisation is not Enabled, this could be due to it being disabled in the BIOS. Before enabling it, check if your processor is compatible.

## Check Processor Compatibility

  1. Identify your Processor
      1. Press the Windows Key
      2. Type "System Information" in the search box
      3. Make a note of your processor make and model
  2. Check Product Specs - Intel:
      1. If your processor is Intel, go to the [Intel Product Specification Page][1] and look up your processor model and open the specification page.
      2. Under the "Advanced Technologies" heading, if Virtualisation is supported, Intel Virtualization Technology (VT-x) will say yes
  3. Check Product Specs - AMD:
      1. If your processor is AMD, go to the [AMD Product Specification Page][2] and look up your processor model and open the specification page.
      2. If the Launch Date is any time after 2007, your CPU supports virtualisation. Unlike Intel, AMD don't reserve Virtualisation technologies for only some of their processors.

 [1]: https://ark.intel.com/content/www/us/en/ark.html
 [2]: https://www.amd.com/en/products/specifications/processors?op=%21%3D&platform=Server
