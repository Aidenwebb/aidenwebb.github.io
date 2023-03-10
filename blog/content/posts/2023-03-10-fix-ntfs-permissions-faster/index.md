---
title: "How to recusively apply NTFS permissions faster using PowerShell multithreading jobs"
date: 2023-03-10T14:49:09Z
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["Powershell", "Scripting", "NTFS", "Permissions", "ACLs", "IT & Tech"]
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
    alt: "A woman looking stressed and frustrated at a laptop" # alt text
    caption: "Photo Credit: [Unsplash](https://unsplash.com/photos/bmJAXAz6ads)" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: true # only hide on current single page
#editPost:
#    URL: "https://github.com/Aidenwebb/aidenwebb-com-blog-code/content"
#    Text: "Suggest Changes" # edit text
#    appendFilePath: true # to append file path to Edit link
---

Do you relate to the cover photo?
Have your NTFS permissions just bombed out and you can't bare the idea of waiting hours or days for your new permissions to apply?

Don't worry, I'm here to help.

It's no secret that applying NTFS permissions to any directory tree larger than a few thousand files quickly decends in to a painstaking waiting game. The built in UI is garbage, and icacls is decent but single-threaded and slow.

I recently had an issue where a directory containing over 15 million files junked its permissions. Using the GUI would have taken days to reset, as would using ICACLS alone. I was not looking forward to the wait so I wrote a PowerShell script utilsing jobs to apply the permissions in parallel. I also included some logic for reporting on the current state of progress, to avoid the blind-waiting and guessing as to when it might actually finish.

You can adjust the script to your needs, as it stands, fire it at a directory and it will run `icalcs /t /c /q /reset` on the directory itself and all sub-items (folders and files) within, while keeping you updated every 30 seconds with how it's doing.

```Powershell
# Report the current state of the script
function Report-ScriptStatus
{
    param(
        $ScriptState
    )

    $currentTime = Get-Date
    $runtime = New-TimeSpan -Start $($ScriptState.startTime) -End $currentTime

    Write-Host "-----"
    Write-Host "Start Time: $($ScriptState.startTime)"
    Write-Host "Current Time: $currentTime"
    Write-Host "Runtime: $runTime"
    
    Write-Host "Completed jobs: $($ScriptState.jobsCompleted.count)"
    foreach ($jobItem in $ScriptState.jobsCompleted) {
        Write-Host " - $($jobItem.Name) | $($jobItem.State) | Started: $($jobItem.PSBeginTime) | Ended: $($jobItem.PsEndTime) | Successes $($jobItem.Successes) | Failures $($jobItem.Failures)"
    }

    $currentlyRunningJobs = get-job | Where-Object {$_.State -eq "Running"}
    Write-Host "Currently running jobs: $($currentlyRunningJobs.Count)"
    $currentlyRunningJobs | foreach-object { Write-Host " - $($_.Name) | $($_.State) | Started: $($_.PSBeginTime)" }
    
    Write-Host "Next Job to Start: $($ScriptState.itemsToProcess[$ScriptState.iterator])"
    Write-Host "Changes Processed - Success:  $($ScriptState.changesProcessedSuccess)"
    Write-Host "Changes Processed - Failed: $($ScriptState.changesProcessedFailed)"



}

# Parse icacls output to get the number of processed files
function Get-IcaclsProcessedFiles {
    param (
        [string]$IcaclsOutput
    )
    <# 
        .SYNOPSIS
        Takes the output of ICACLS and returns the number of successfully processed files.

        .PARAMETER IcaclsOutput
        The string of icacls output. EG Successfully processed 11 files; Failed processing 5 files

        .OUTPUTS
        Two numbers, the first is the number of successfully processed files, the second is the failed processed files.
    #>

    $successfulFiles = ($icaclsOutput.split(";")  -replace "[^0-9]", '')[0]
    $failedFiles = ($icaclsOutput.split(";")  -replace "[^0-9]", '')[1]

    return @($successfulFiles, $failedFiles)
    
}

# Start the job, modify the command to suit your needs
function Start-IcaclsJob {

    param($TargetItemFullName)

    Write-Host "Starting job for item: icacls - $TargetItemFullName"

    $job = {
        param($loc)
        Invoke-Expression -Command "icacls $loc /t /c /q /reset'"  ### ADD YOUR OWN ICACLS command/flags here
    }

    Start-Job -Name "icacls - $targetItemFullName" -ScriptBlock $job -ArgumentList $targetItemFullName
}

function Fix-MyDamnPermissions {
    param(
        [string]$TargetFolder,
        [bool]$ProcessSubfoldersOnly = $false, # Set to True to only process subfolders, not the root folder
        [int]$MaxConcurrentJobs = 20,
        [int]$TimeBetweenReportsSeconds = 30
    )

    $scriptState = [PSCustomObject]@{
        startTime = Get-Date
        lastReportTime = Get-Date -Date "01/01/1970"

        itemsToProcess = @()
        iterator = 0

        jobsCompleted = @()
        changesProcessedSuccess = 0
        changesProcessedFailed = 0
        exitLoop = 0
    }

    if (-not $ProcessSubfoldersOnly) {
        $scriptState.itemsToProcess += Get-Item $TargetFolder 
    }
    
    $scriptState.itemsToProcess += Get-ChildItem $TargetFolder -Depth 0
    
    while ($true) {

        # Check if we have more items to process
        if ($scriptState.iterator -lt $scriptState.itemsToProcess.Count) {

            # Check if we can start new jobs
            $JobsRunning = get-job | Where-Object {$_.State -eq "Running"}
            if ($JobsRunning.Count -lt $MaxConcurrentJobs) {

                $nextItemToProcess = $scriptState.itemsToProcess[$scriptState.iterator]

                Start-IcaclsJob -TargetItemFullName $nextItemToProcess.fullname
                ($scriptState.iterator)++
            }

        }
        else {
            $allJobsQueued = $true
        }

        # Tidy up completed jobs
        $jobsCompletedSinceLastCheck = get-job | Where-Object {$_.State -eq "Completed"}
        
        foreach ($jobItem in $jobsCompletedSinceLastCheck) {
            
            $filesprocessed = Get-IcaclsProcessedFiles -icaclsOutput $jobItem.ChildJobs[0].Output
            $scriptState.changesProcessedSuccess += $filesprocessed[0]
            $scriptState.changesProcessedFailed += $filesprocessed[1]
            
            $jobitem | add-member -type NoteProperty -Name Successes -Value $filesprocessed[0]
            $jobItem | add-member -type NoteProperty -Name Failures -Value $filesprocessed[1]
            $scriptState.jobsCompleted += $jobItem

            Remove-Job $jobItem
        }

        # Check if we need to process the report
        $timeSinceLastReport = New-TimeSpan -start $scriptState.lastReportTime -end (Get-Date)
        if ($timeSinceLastReport.TotalSeconds -gt $TimeBetweenReportsSeconds) {

            Report-ScriptStatus -ScriptState $scriptState
            $scriptState.lastReporttime = Get-Date
        }

        if ($allJobsQueued) {
            $AllJobs = get-job

            if ($AllJobs.Count -eq 0) {
                # All jobs run, report and break
                Report-ScriptStatus -ScriptState $scriptState
                
                # Make sure we capture anything in the final iteration
                ($scriptState.exitLoop)++

                if ($scriptState.exitLoop -gt 1) {

                    break
                }
            }
        }
    }

}

### Example usage
Fix-MyDamnPermissions -TargetFolder "C:\Temp\Permissions"
```