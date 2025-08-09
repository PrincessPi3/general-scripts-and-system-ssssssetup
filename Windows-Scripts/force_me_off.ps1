param (
    [Single]$Hours = 1,

    [Single]$Minutes = 0,

    [Single]$grace_minutes = 2
)

# some calcs
$wait_minutes = (($Hours*60)+$Minutes)
$wait_seconds = ($wait_minutes*60)
$total_wait_minutes = ($wait_minutes+$grace_minutes)
$total_wait_seconds = ($total_wait_minutes*60)
$grace_seconds = ($grace_minutes*60)

Write-Host "wait_seconds $wait_seconds wait_minutes $wait_minutes hours $Hours minutes $Minutes grace_seconds $grace_seconds grace_minutes $grace_minutes total_wait_minutes $total_wait_minutes"

Write-Host "`nFORCING YOUR STUPID ASS OFF IN $Hours hours $Minutes minutes plus $grace_minutes minutes grace period`n"

# current time
Write-Host "$(Get-Date -Format 'hh:mm:ss tt') | Start Time"

# shutdown time
Write-Host "$((Get-Date).AddHours($Hours).AddMinutes($total_wait_minutes).ToString("hh:mm:ss tt")) | Reboot Time"

Write-Host "`nSleeping for $Hours hours $Minutes minutes and forking to background to prevent cheating...`n"

function do_admin_shit {
    # handle interactive shit right away
    ## schedule chkdsk to take up fuckin tons of time
    Start-Process -Verb RunAs -FilePath cmd.exe -ArgumentList  '/C "chkdsk /r C:"'
    # Start-Process -Verb RunAs -FilePath cmd.exe -ArgumentList  '/K "chkdsk /r E: && chkdsk /r D: && chkdsk /r C: && exit"'
    ## must use fuckin cmd bullshit grumble grumble
    ## cancel with shutdown /a
    shutdown /f /r /t $total_wait_seconds

    # sleep
    Start-Sleep -Seconds $total_wait_seconds

    ## popup
    $shell = New-Object -ComObject 'WScript.Shell'
    # $shell.Popup(string <MESSAGE>, int <MODE>, string <WINDOW_TITLE>, int <CONTROLS>)
    $shell.Popup("REBOOTING BY FORCE IN $grace_minutes MINUTES", 2, "REBOOTING AS FUCK IN $grace_minutes MINUTES", 0)    ## reboot, force, delay $grace_seconds seconds
}

do_admin_shit | Out-Null