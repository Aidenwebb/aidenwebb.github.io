---
title: How to Hard Link Azure AD Connect On Prem Users to Azure AD Office 365 Accounts
author: Aiden Arnkels-Webb
#type: post
date: 2022-03-03T10:36:09+00:00
url: /how-to-hard-link-azure-ad-connect-on-prem-users-to-azure-ad-office-365-accounts/
cover:
    image: "/images/firefox_jyFKgOIryS.png" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: false # only hide on current single page
featured_image: /images/firefox_jyFKgOIryS.png
draft: false
---
## The Problem

You&#8217;ve set up Azure AD Connect or Azure AD Connect Cloud Sync, but some users haven&#8217;t sync&#8217;d correctly. Trying to force a new sync / Soft Link based on SMTP or UPN matching doesn&#8217;t work. These sync&#8217;d users may have created new Azure AD accounts, or may have failed to create an Azure AD account altogether. Your internal users UPN matches a domain configured in Azure AD.

## The Cause

The initial soft link matches on UPN or SMTP, but may fail if there are conflicting ProxyAddresses.

## The Fix

Linking On Premises accounts and Azure AD accounts involves matching the GUID of the On-Premises account with the ImmutableID property of the Azure AD account. This property can be written to using the Azure Powershell module.

We need to manually apply the ImmutableID property to the Azure AD account.

Open an elevated Powershell prompt on a system that is able to access Active Directory and the internet

**0:** Install required modules

<pre class="wp-block-code"><code>Install-Module -Name AZ
Add-WindowsCapability –online –Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0</code></pre>

**0.1:** Connect to Azure online

<pre class="wp-block-code"><code>Connect-MsolService</code></pre>

**1:** Get the GUID of your on-premises user:

<pre class="wp-block-code"><code>$guid = (Get-ADUser -Identity "James.Bond").ObjectGUID</code></pre>

**2:** Convert the GUID to the ImmutableID used to hardlink in Azure AD

<pre class="wp-block-code"><code>$immutableid=&#91;System.Convert]::ToBase64String($guid.tobytearray())</code></pre>

**3:** Check if a user in Azure AD is using this ImmutableID already

<pre class="wp-block-code"><code>Get-MsolUser | Where-Object {$_.immutableid -eq $immutableid}</code></pre>

**4.1:** <DANGER>: If the Azure AD user using the ImmutableID isn&#8217;t an account in use, and you have no need for it, delete it completely.

<pre class="wp-block-code"><code>Get-MsolUser | Where-Object {$_.immutableid -eq $immutableid} | Remove-MsolUser
Get-MsolUser | Where-Object {$_.immutableid -eq $immutableid} | Remove-MsolUser -RemoveFromRecycleBin</code></pre>

**4.2:** If the Azure AD user using the Immutable ID is an account that you use, and you don&#8217;t want to delete it, set its ImmutableID to Null

<pre class="wp-block-code"><code>Get-MsolUser | Where-Object {$_.immutableid -eq $immutableid} | Set-MsolUser -ImmutableId $null</code></pre>

**5:** Find the UPN of the Azure AD user you want to Hard Link

**6:** Set the ImmutablieID on the correct AD user

<pre class="wp-block-code"><code>Set-MsolUser -UserPrincipalName James.Bond@CorrectCloudUpnDomain.com -ImmutableId $immutableid</code></pre>