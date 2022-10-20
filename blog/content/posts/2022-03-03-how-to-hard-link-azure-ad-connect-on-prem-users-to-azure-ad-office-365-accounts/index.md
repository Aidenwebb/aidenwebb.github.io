---
title: How to Hard Link Azure AD Connect On Prem Users to Azure AD Office 365 Accounts
author: Aiden Arnkels-Webb
#type: post
date: 2022-03-03T10:36:09+00:00
#url: 
aliases:
    - /how-to-hard-link-azure-ad-connect-on-prem-users-to-azure-ad-office-365-accounts/
cover:
    image: "cover.png" # image path/url
    alt: "Error code: AzureDirectoryServiceAttributeValueMustBeUnique" # alt text
    caption: "Error code: AzureDirectoryServiceAttributeValueMustBeUnique" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
tags: ["Azure", "Troubleshooting", "Azure AD", "Azure AD Connect", "IT & Tech"]
draft: false
---
## The Problem

You've set up Azure AD Connect or Azure AD Connect Cloud Sync, but some users haven't sync'd correctly. Trying to force a new sync / Soft Link based on SMTP or UPN matching doesn't work. These sync'd users may have created new Azure AD accounts, or may have failed to create an Azure AD account altogether. Your internal users UPN matches a domain configured in Azure AD.

## The Cause

The initial soft link matches on UPN or SMTP, but may fail if there are conflicting ProxyAddresses.

## The Fix

Linking On Premises accounts and Azure AD accounts involves matching the GUID of the On-Premises account with the ImmutableID property of the Azure AD account. This property can be written to using the Azure PowerShell module.

We need to manually apply the ImmutableID property to the Azure AD account.

Open an elevated PowerShell prompt on a system that is able to access Active Directory and the internet

### In Preparation

1. Install required modules

    ```powershell {linenos=true}
    Install-Module -Name AZ
    Add-WindowsCapability –online –Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
    ```

2. Connect to Azure online

    ```powershell {linenos=true}
    Connect-MsolService
    ```

### Resolution steps

1. Get the GUID of your on-premises user:

    ```powershell
    $guid = (Get-ADUser -Identity "James.Bond").ObjectGUID
    ```

2. Convert the GUID to the ImmutableID used to hardlink in Azure AD

    ```powershell
    $immutableid=[System.Convert]::ToBase64String($guid.tobytearray())
    ```

3. Check if a user in Azure AD is using this ImmutableID already

    ```powershell
    Get-MsolUser | Where-Object {$_.immutableid -eq $immutableid}
    ```

4. Either:

   1. ⚠️**DANGER**⚠️: If the Azure AD user using the ImmutableID isn't an account in use, and you have no need for it, delete it completely.

        ```powershell
        Get-MsolUser | Where-Object {$_.immutableid -eq $immutableid} | Remove-MsolUser
        Get-MsolUser | Where-Object {$_.immutableid -eq $immutableid} | Remove-MsolUser -RemoveFromRecycleBin
        ```

   2. If the Azure AD user using the Immutable ID is an account that you use, and you don't want to delete it, set its ImmutableID to Null

        ```powershell
        Get-MsolUser | Where-Object {$_.immutableid -eq $immutableid} | Set-MsolUser -ImmutableId $null
        ```

5. Find the UPN of the Azure AD user you want to Hard Link

6. Set the ImmutablieID on the correct AD user

    ```powershell
    Set-MsolUser -UserPrincipalName James.Bond@CorrectCloudUpnDomain.com -ImmutableId $immutableid
    ```
