param (
    [Int16]
    $Hours = 1,

    [Int16]
    $Minutes = 0,

    [Int16]
    $grace_minutes = 2
)

# some calcs
$wait_minutes = (($Hours*60)+$Minutes)
$wait_seconds = ($wait_minutes*60)
$grace_seconds = ($grace_minutes*60)
$stop_time = $((Get-Date).AddHours($Hours).AddMinutes(($grace_minutes+$Minutes)).ToString("hh:mm:ss tt"))

# notify of time
Write-Host "`nFORCING YOUR STUPID ASS OFF IN $Hours hours $Minutes minutes plus $grace_minutes minutes grace period"

# webhook
Write-Host "Sending webhook notification..."
webhook "FORCING REBOOT AT $stop_time`n"

# current time
Write-Host "$(Get-Date -Format 'hh:mm:ss tt') | Start Time"

# shutdown time
Write-Host "$stop_time | Reboot Time"

Write-Host "`nSleeping for $Hours hours $Minutes minutes and forking to the background to prevent cheating`n"

Start-Job -ScriptBlock {
    # sleep
    Start-Sleep -Seconds $wait_seconds

    # do an offline chkdisk to force more time away from computer lmfao
    # chkdsk /r C:

    # force reboot using the cmd because powershell is cancer
    shutdown /r /t $grace_seconds # Restarts after a delay
}  | Out-Null # maek it queitrerr