# usage force_me_off -Hours <int> -Minutes <int> -GraceMinutes <int>
# default one hour, zero minutes, zero grace minutes
param (
    [Single]$Hours = 1,

    [Single]$Minutes = 0,

    [Single]$GraceMinutes = 0
)

# some calcs
$wait_minutes = (($Hours*60)+$Minutes)
$total_wait_minutes = ($wait_minutes+$GraceMinutes)
$total_wait_seconds = ($total_wait_minutes*60)
$reboot_time = $((Get-Date).AddHours($Hours).AddMinutes($Minutes + $GraceMinutes).ToString("hh:mm:ss tt"))
function ForceOff {
    # time wasters
    ## checks C drive after reboot to waste time and fix errors
    ## chkdsk /r C: # as admin
    chkdsk /r C:
    pause # pause for clarity

    # Do the sleep
    Start-Sleep -Seconds $total_wait_seconds

    # do reboot
    ## schedule shutdown
    ## redundant but also for warnings
    ### reboot (-r) forced (-t) in seconds (-t)
    shutdown -r -f -t ($total_wait_seconds+10) # 10 second bonus to defer to Start-MpWDOScan
    ## Start Windows Defender Offline Scan
    ## wastes time
    ## does the actual reboot
    Start-MpWDOScan
}

# force admin and disable previously scheduled shutdown
# environment
## Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Restart with elevated privileges
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`""
    exit
}
## clean up any sched backups
shutdown -a

# post to terminal and send webhook
# notify user
## Warning
Write-Host "`nFORCING YOUR STUPID ASS OFF IN $Hours hours $Minutes minutes plus $GraceMinutes minutes grace period`n"
## current time
Write-Host "$(Get-Date -Format 'hh:mm:ss tt') | Start Time"
## shutdown time
Write-Host "$reboot_time | Reboot Time"
## send da webhookd thingggg
webhook "FORCING OFF FROM WINDOWS AT $reboot_time" true

# time wasters
## checks C drive after reboot to waste time and fix errors
## chkdsk /r C: # as admin
chkdsk /r C:
pause # pause for clarity

Start-Process -ScriptBlock {
    # Do the sleep
    Start-Sleep -Seconds $total_wait_seconds

    # do rebot
    ## schedule shutdown
    ## redundant but also for warnings
    ### reboot (-r) forced (-t) in seconds (-t)
    shutdown -r -f -t ($total_wait_seconds+10) # 10 second bonus to defer to Start-MpWDOScan
    ## Start Windows Defender Offline Scan
    ## wastes time
    ## does the actual reboot
    Start-MpWDOScan
}