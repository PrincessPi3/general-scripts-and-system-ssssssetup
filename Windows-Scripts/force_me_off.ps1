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
$total_wait_minutes = ($wait_minutes+$grace_minutes)
$grace_seconds = ($grace_minutes*60)
$stop_time = "$((Get-Date).AddHours($Hours).AddMinutes($total_wait_minutes).ToString("hh:mm:ss tt"))"

Write-Host "`nFORCING YOUR STUPID ASS OFF IN $Hours hours $Minutes minutes plus $grace_minutes minutes grace period`n"

# current time
Write-Host "$(Get-Date -Format 'hh:mm:ss tt') | Start Time"

# shutdown time
Write-Host " | Reboot Time"

webhook "FORCING REBOOT AT $stop_time"

Write-Host "`nSleeping for $Hours hours $Minutes minutes...`n"

# sleep
Start-Sleep -Seconds ($wait_seconds)

# force reboot
Write-Host "FORCING REBOOT IN $grace_minutes MINUTES"
Restart-Computer -Force -Timeout $grace_seconds