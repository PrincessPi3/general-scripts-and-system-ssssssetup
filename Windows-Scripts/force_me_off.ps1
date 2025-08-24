param (
    [Single]$Hours = 1,

    [Single]$Minutes = 0,

    [Single]$grace_minutes = 2
)

# some calcs
$wait_minutes = (($Hours*60)+$Minutes)
# $wait_seconds = ($wait_minutes*60)
$total_wait_minutes = ($wait_minutes+$grace_minutes)
$total_wait_seconds = ($total_wait_minutes*60)
$grace_seconds = ($grace_minutes*60)
$reboot_time = $((Get-Date).AddHours($Hours).AddMinutes($Minutes + $grace_minutes).ToString("hh:mm:ss tt"))
# Write-Host "wait_seconds $wait_seconds wait_minutes $wait_minutes hours $Hours minutes $Minutes grace_seconds $grace_seconds grace_minutes $grace_minutes total_wait_minutes $total_wait_minutes reboot_time $reboot_time"
$popup_shell = New-Object -ComObject 'WScript.Shell'

Write-Host "`nFORCING YOUR STUPID ASS OFF IN $Hours hours $Minutes minutes plus $grace_minutes minutes grace period`n"

# clean up any running
shutdown /a

# current time
Write-Host "`n$(Get-Date -Format 'hh:mm:ss tt') | Start Time"

# shutdown time
Write-Host "$reboot_time | Reboot Time"

Write-Host "`nSleeping for $Hours hours $Minutes minutes and forking to background to prevent cheating...`n"

webhook "SCHEDULED REBOOT AT $reboot_time" true

# popup
$popup_shell.Popup("REBOOTING BY FORCE IN $Hours HOURS $Minutes MINUTES AT $reboot_time", 2, "REBOOTING AS FUCK IN $total_wait_minutes MINUTES", 0) | Out-Null

# schedule chkdsk to take up fuckin tons of time
Start-Process -FilePath cmd.exe -ArgumentList '/C "chkdsk /r C:"'

# set to reboot with windows defender offline scan scheduled to wastte even more time :wheeze:
Start-Process -FilePath powershell.exe -ArgumentList '-C "Start-MpWDOScan"'

# must use fuckin cmd bullshit grumble grumble
Start-Sleep -Seconds $total_wait_seconds

# popup
$popup_shell.Popup("REBOOTING BY FORCE IN $grace_minutes MINUTES", 2, "REBOOTING AS FUCK IN $grace_minutes MINUTES", 0) | Out-Null

# grace sleep
Start-Sleep -Seconds $grace_seconds

# reboot in 120 seconds
shutdown /r /t 120