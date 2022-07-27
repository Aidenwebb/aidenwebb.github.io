---
title: "What's the difference between Authentication, Authorisation and Accounting? (AAA)"
date: 2022-07-27T12:36:29+01:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["Security", "Authentication", "Authorisation", "Explainers", "IT & Tech"]
author: "Aiden Arnkels-Webb"
showToc: true
TocOpen: false
hidemeta: false
comments: false
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
    image: "cover.jpg" # image path/url
    alt: "Picture of Microsoft Authenticator" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: false # only hide on current single page
---

## Authentication
Authentication is saying "I am me". It validates who you are.
When you go to a club and the bouncer stops you and you tell him you're on the guest list, you then show him your ID and he says "Ahh! You're that guy, come on in" - that's Authentication

## Authorisation
Authorisation validates what you claim to be. Going back to the club and the bouncer stops you. You show him your ID. He authenticates you and that your ID belongs to you by checking your picture matches your face. He then checks your authorisation by checking your date of birth to validate that you're old enough to come in, but otherwise doesn't care who you are. He only cares about your age. Your date of birth here is what's called a claim. It's something your ID token claims to be true about you. 

## Accounting
Accounting validates what you do once you have access. Back to the club, the bouncer gives you a wristband. This wristband is used for everything at the club, from buying drinks, to accessing the dancefloor, to going to the toilet. Every time your wristband is used, where and when it is used is logged. These logs in aggregate form a detailed picture of what you did during your time at the club.