---
title: "How to set up K-9 Mail With Office 365"
date: 2022-11-05T10:12:52Z
draft: true
# weight: 1
# aliases: ["/first"]
tags: ["Microsoft 365", "Office 365", "K-9 Mail", "Email", "Useful Tools"]
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
    alt: "K-9 Mail logo" # alt text
    #caption: "Photo Credit: []()" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: true # only hide on current single page
#editPost:
#    URL: "https://github.com/Aidenwebb/aidenwebb-com-blog-code/content"
#    Text: "Suggest Changes" # edit text
#    appendFilePath: true # to append file path to Edit link
---

I have a hell of a lot of mail accounts, K-9 Mail on Android helps me manage them all.
Here's how to set up K-9 Mail with Office 365.

You will first need to set up SMTP Auth on your Exchange Tenant. This is a simple process, but it does require you to have access to the Exchange Admin Centre. If you don't have access to the EAC, you'll need to ask your Exchange Admin to do this for you.

A guide is available here: <https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/authenticated-client-smtp-submission>

## IMAP (incoming)

- IMAP server: outlook.office365.com
- Security: SSL/TLS
- Port: 993
- Username: your email
- Authentication: OAuth2
  - Auto-detect IMAP namespace: checked
  - Use compression: checked

## SMTP (outgoing)

- SMTP server: smtp.office365.com
- Security: STARTTLS
- Port: 587
- Require sign-in: checked
- Username: your email
- Authentication: OAuth2

## Notes

- If you have 2FA enabled on your account, you will need to generate an app password for K-9 Mail to use. This is a one-time password that you can generate in the Office 365 portal.
- Auto-detect IMAP namespace is a new feature in K-9 Mail 5.800. It allows K-9 Mail to automatically detect the namespace of your IMAP server. This is useful if you have multiple mailboxes on the same server, as it allows you to select which mailbox you want to use.
- auto-detect IMAP namespace is not available in K-9 Mail 5.600 and older. If you are using K-9 Mail 5.600, you will need to manually set the namespace to "INBOX.".
