param (
    [Single]$Hours = 1,
    
    [Single]$Minutes = 0,

    [Single]$grace_minutes = 2
)

# some calcs
$wait_minutes = (($Hours*60)+$Minutes)
$wait_seconds = ($wait_minutes*60)
$total_wait_minutes = ($wait_minutes+$grace_minutes)
$grace_seconds = ($grace_minutes*60)

# Write-Host "wait_seconds $wait_seconds wait_minutes $wait_minutes hours $Hours minutes $Minutes grace_seconds $grace_seconds grace_minutes $grace_minutes total_wait_minutes $total_wait_minutes"

Write-Host "`nFORCING YOUR STUPID ASS OFF IN $Hours hours $Minutes minutes plus $grace_minutes minutes grace period`n"

# current time
Write-Host "$(Get-Date -Format 'hh:mm:ss tt') | Start Time"

# shutdown time
Write-Host "$((Get-Date).AddHours($Hours).AddMinutes($total_wait_minutes).ToString("hh:mm:ss tt")) | Reboot Time"

Write-Host "`nSleeping for $Hours hours $Minutes minutes...`n"

# sleep
Start-Sleep -Seconds $wait_seconds

# chkdsk to take up fuckin tons of time
chkdsk /r

# force reboot
Write-Host "FORCING REBOOT IN $grace_minutes MINUTES"
Restart-Computer -Force -Wait -For PowerShell -Timeout $grace_seconds