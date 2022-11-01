---
title: "How to Migrate T-SQL to a new server"
date: 2022-08-02T14:37:43+01:00
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
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "Photo Credit: []()" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: true # only hide on current single page
#editPost:
#    URL: "https://github.com/Aidenwebb/aidenwebb-com-blog-code/content"
#    Text: "Suggest Changes" # edit text
#    appendFilePath: true # to append file path to Edit link
---

A non-comprehensive overview of how to migrate databases to a new T-SQL server

## Gather information

### Features

1. Run SQL Server Setup
2. Navigate through the wizard: Installation > New SQL Server stand-alone installation or add features to an existing installation
3. 

### Configuration

```SQL
SELECT * FROM sys.configurations;
-- OR
EXEC SP_CONFIGURE
```

### Collation

Note down each tables Collation information:

```SQL
SELECT name, collation_name FROM sys.databases;
```

## Create user scripts

TODO: Rewrite https://www.mssqltips.com/sqlservertip/2901/how-to-change-server-level-collation-for-a-sql-server-instance/

Create and prepare all scripts related to jobs, maintenance plans, logins and their access levels. You can generate scripts by selecting all jobs in object explorer in SSMS and right click on your selection then choose the "script as" option to create the script for all jobs.  You can do similar steps to generate scripts for alerts and operators as well. The below screenshot to generate scripts for all your jobs.

[Transfer logins and passwords between instances](https://docs.microsoft.com/en-us/troubleshoot/sql/security/transfer-logins-passwords-between-instances)

## Back up databases

## Set up new SQL Server Instance

1. Set Collation

## Create users

## Import database backups

## 