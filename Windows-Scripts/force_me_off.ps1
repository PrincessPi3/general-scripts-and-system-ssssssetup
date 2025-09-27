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

# environment
## Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Restart with elevated privileges
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`""
    exit
}
## clean up any sched backups
shutdown /a

# time wasters
## checks C drive after reboot to waste time and fix errors
## chkdsk /r C: # as admin
chkdsk /r C:
pause # pause for clarity
## starts Windows Defender Offline Scan after reboot
Start-MpWDOScan;
pause # pause for clarity

# notify user
## Warning
Write-Host "`nFORCING YOUR STUPID ASS OFF IN $Hours hours $Minutes minutes plus $GraceMinutes minutes grace period`n"
## current time
Write-Host "$(Get-Date -Format 'hh:mm:ss tt') | Start Time"
## shutdown time
Write-Host "$reboot_time | Reboot Time"
## send da webhookd thingggg
webhook "FORCING OFF FROM WINDOWS AT $reboot_time" true

# schedule (/t) forced (/f) reboot (/r)
Write-Host shutdown /r /f /t $total_wait_seconds
Write-Host "`nSCHEDULED REBOOT IN $total_wait_seconds seconds`n"
pause # pause for clarity in the new window