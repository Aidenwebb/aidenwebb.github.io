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

function Start-IcaclsJob {

    param($TargetItemFullName)

    Write-Host "Starting job for item: icacls - $TargetItemFullName"

    $job = {
        param($loc)
        Invoke-Expression -Command "icacls $loc /grant:r 'NT AUTHORITY\IUSR:(OI)(CI)(M)' /grant:r 'BUILTIN\Users:(OI)(CI)(M)' /grant:r 'NT AUTHORITY\SYSTEM:(OI)(CI)(F)' /grant:r 'BUILTIN\Administrators:(OI)(CI)(F)' /grant:r 'BUILTIN\Users:(OI)(CI)(RX)' /grant:r 'BUILTIN\Users:(CI)(AD)' /grant:r 'BUILTIN\Users:(CI)(WD)' /grant:r 'MicroSiteWebSvr\Aztec3:(F)' /grant:r 'CREATOR OWNER:(OI)(CI)(IO)(F)'"
    }

    Start-Job -Name "icacls - $targetItemFullName" -ScriptBlock $job -ArgumentList $targetItemFullName
}

function Fix-MyDamnPermissions {
    param(
        [string]$TargetFolder,
        [int]$MaxConcurrentJobs = 20,
        [int]$TimeBetweenReportsSeconds = 5
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

    $scriptState.itemsToProcess += Get-Item $TargetFolder
    $scriptState.itemsToProcess += Get-ChildItem $TargetFolder -Depth 0
    
    while ($true) {

        # Check if we have more items to process
        if ($scriptState.iterator -lt $scriptState.itemsToProcess.Count) {
            <# Action to perform if the condition is true #>

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

        # Check completed jobs
        # Report on and tidy up completed jobs
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

        # Check if we need to report
        $timeSinceLastReport = New-TimeSpan -start $scriptState.lastReportTime -end (Get-Date)
        if ($timeSinceLastReport.TotalSeconds -gt $TimeBetweenReportsSeconds) {

            Report-ScriptStatus -ScriptState $scriptState
            $scriptState.lastReporttime = Get-Date
        }

        if ($allJobsQueued) {
            $AllJobs = get-job
            $JobsCompletedFinal = get-job | Where-Object {$_.State -eq "Completed"}

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

Fix-MyDamnPermissions -TargetFolder "C:\Temp\Permissions"