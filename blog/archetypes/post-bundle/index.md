---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
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