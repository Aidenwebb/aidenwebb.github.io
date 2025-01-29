---
title: "Create Dynamic User Pilot groups in Microsoft Entra"
date: 2025-01-29T18:46:03Z
draft: false
# weight: 1
# aliases: ["/first"]
tags: 
- Azure
- Microsfot365
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
# cover:
    # image: "images/cover.webp" # image path/url
    # alt: "Digital artwork depicting the concept of Cloud-init technology in a hypervisor environment. The image features a central, stylized cloud with intricate digital circuit patterns, symbolizing Cloud-init. Surrounding the cloud are interconnected, floating, semi-transparent cubes with glowing edges, each representing a hypervisor. Faint streams of binary code flow between these cubes, illustrating virtualization and connectivity. The background is a gradient of blue shades, representing technology and innovation, with subtle abstract digital patterns enhancing the futuristic theme." # alt text
    # caption: "Image Credit: Generated with DALL-E" # display caption under cover
    # relative: true # when using page bundles set this to true
    # hidden: false # only hide on current single page
#editPost:
#    URL: "https://github.com/Aidenwebb/aidenwebb-com-blog-code/content"
#    Text: "Suggest Changes" # edit text
#    appendFilePath: true # to append file path to Edit link
---

As IT professionals, we often find the need to push out changes to a small subset of our full user base.
Manually maintaining pilot groups with users joining and leaving can create a lot of overhead.

A better way is using Dynamic groups - but how do you segment users cleanly in to different groups automatically? How do you avoid capturing Guests, or other non-human user accounts?

The answer is Dynamic queries.

We can use the user.objectId property to act as our random seed for splitting users in to groups. As a GUID, the user.objectid property's first character will always be between 0-9 or a-f.
With 16 different options, each individual character has a 6.25% chance of occurring.

We can use the user.userType property to differentiate between Members of the tenant and Guests. Use `user.userType -eq "Member"` for tentant members, or `user.userType -eq "Guest"` for Guests

`user.accountEnabled -eq true` ensures we only capture enabled users. Disabled users like leavers are automatically excluded

`(user.assignedPlans -any (assignedPlan.servicePlanId -eq "c1ec4a95-1f05-45b3-a911-aa3fa01094f5" -and assignedPlan.capabilityStatus -eq "Enabled"))` captures users with a Microsoft 365 Business Premium licence. Change the GUID for servicePlanId to your preferred licecne type.
A reference for service plan ID's is availabe [here](https://learn.microsoft.com/en-us/entra/identity/users/licensing-service-plan-reference)

Here are the rings I use 

## User_Pilot_Ring_1

Dynamic Query:

```
(user.objectId -startsWith "0") and (user.userType -eq "Member") and (user.accountEnabled -eq true) and (user.assignedPlans -any (assignedPlan.servicePlanId -eq "c1ec4a95-1f05-45b3-a911-aa3fa01094f5" -and assignedPlan.capabilityStatus -eq "Enabled"))
```

## User_Pilot_Ring_2

Dynamic Query:

```
(user.objectId -match "^[0-4]") and (user.userType -eq "Member") and (user.accountEnabled -eq true) and (user.assignedPlans -any (assignedPlan.servicePlanId -eq "c1ec4a95-1f05-45b3-a911-aa3fa01094f5" -and assignedPlan.capabilityStatus -eq "Enabled"))
```

## User_Pilot_Ring_3

Dynamic Query:

```
(user.objectId -match "^[0-9]|^[a-b]") and (user.userType -eq "Member") and (user.accountEnabled -eq true) and (user.assignedPlans -any (assignedPlan.servicePlanId -eq "c1ec4a95-1f05-45b3-a911-aa3fa01094f5" -and assignedPlan.capabilityStatus -eq "Enabled"))
^[0-9]|[a-b]
```
