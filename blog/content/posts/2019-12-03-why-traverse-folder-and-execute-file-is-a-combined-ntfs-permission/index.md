---
title: Why “traverse folder” and “execute file” is a combined NTFS permission
author: Aiden Arnkels-Webb
#type: post
date: 2019-12-03T13:02:00+00:00
aliases:
  - /why-traverse-folder-and-execute-file-is-a-combined-ntfs-permission/
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
  - Resources & Guides
tags:
  - Access Control
  - Windows Server
  - Reference Guide

---
I've been asked why the Advanced Permissions dialogue on NTFS folders lists "Traverse folder / execute file" as one single permission.

On the surface it seems counterintuitive that you'd allow a user to navigate through a folder, or execute its contents.

There's no official Microsoft documentation on the design decisions, however, from a filesystem perspective, entering a folder is the same as executing or running it. The same is true of 3 classic Unix filesystem flags and permissions, where the "X" flag allows both directory traversal and file execution, while "R" allows reading and "W" allows writing.
