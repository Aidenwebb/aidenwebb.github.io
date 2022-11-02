---
title: "How to replace SSL certificates for a custom domain in Self Hosted 3CX"
date: 2022-11-02T09:22:23Z
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["3CX", "Self Hosted", "SSL Certificates"]
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
  alt: "3CX Logo" # alt text
  caption: "Photo Credit: [ClipArtMax](https://www.clipartmax.com/middle/m2i8H7A0A0H7i8G6_3cx-phone-system-3cx-logo/)" # display caption under cover
  relative: true # when using page bundles set this to true
  hidden: false # only hide on current single page
#editPost:
#  URL: "https://github.com/Aidenwebb/aidenwebb-com-blog-code/content"
#  Text: "Suggest Changes" # edit text
#  appendFilePath: true # to append file path to Edit link
---

3CX have updated their docs and removed `help.3cx.com` meaning the old documentation for updating SSL certs is now gone, or at least harder to find.

The original URL was `https://help.3cx.com/help/en-us/33-installation/148-how-can-i-replace-the-ssl-certificates-for-a-custom-domain`. If anyone has a copy of this page, please let me know.

Thankfully updating the SSL certificate is relatively straight forward as the web client runs on nginx.

## Updating the SSL Certificate

### Prerequisites

You will need:

* Access to the server running 3CX
  * Remote Desktop (Windows)
  * SSH (Linux)
* The certificate and private key in PEM format

### Updating the Certificate

Locate the certificate folder (default):

* Windows: `C:\Program Files\3CX Phone System\Bin\nginx\conf\instance1`
* Linux: `/var/lib/3cxpbx/Bin/nginx/conf/Instance1`

Copy the certificate and private key into the folder and rename them to `<yourdomain>-crt.pem` and `<yourdomain>-key.pem` respectively.
EG:

* `mydomain-com-crt.pem`
* `mydomain-com-key.pem`

### Restart Nginx

Restart the nginx service to apply the new certificate.

* Windows: `net stop nginx` then `net start nginx`
* Linux: `systemctl restart nginx`
