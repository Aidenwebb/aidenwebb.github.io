---
title: "Handy Regex patterns"
date: 2023-06-06T13:55:50Z
draft: true
# weight: 1
# aliases: ["/first"]
tags: ["first"]
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
    alt: "<alt text>" # alt text
    caption: "Photo Credit: []()" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: true # only hide on current single page
#editPost:
#    URL: "https://github.com/Aidenwebb/aidenwebb-com-blog-code/content"
#    Text: "Suggest Changes" # edit text
#    appendFilePath: true # to append file path to Edit link
---

Just a quick post to start capturing some handy regex patterns I use.

## Capture valid domains

[regex101 link](https://regex101.com/r/Ds7v5J/2)

```regex
^(((?!-))(xn--|_)?[a-zA-Z0-9-]{0,61}[a-zA-Z0-9]{1,1}\.)*(xn--)?([a-zA-Z0-9][a-zA-Z0-9\-]{0,60}|[a-zA-Z0-9-]{1,30}\.[a-zA-Z]{2,})$
```
