# usage:
## All paramaters are optional
## All paramaters are compatible with each other
## Default behavior is to restart immediately after zero time
##  IM_SO_TIRED_BOSS -Seconds <int seconds> -Minutes <int minutes> -Hours <int hours> -ChkDsk $True
## Examples:
###     IM_SO_TIRED_BOSS -Minutes 90
###     IM_SO_TIRED_BOSS -Minutes 30 -Hours 1
###     IM_SO_TIRED_BOSS -Minutes 30 -ChkDsk $True

Param(
    [int]$Seconds = 0,
    [int]$Minutes = 0,
    [int]$Hours = 0,
    [bool]$ChkDsk = $false
)

# Force off for longer by doing offline modern chkdsk to tie up your computer to be unusable for a while
# pipes y to it so its noninteractive
# auto elevates to admin when run with -ChkDsk $True
if ($ChkDsk) {
    # elevate to admin
    # set for offline chkdsk noninteractively by piping y to it lmao
    # runs a cmd window as admin running "echo y | chkdsk C: /f /r" which then closes
    Start-Process cmd.exe -Verb RunAs -ArgumentList "/c echo y | chkdsk C: /f /r"
}

# Current date object
$CurrentTime = Get-Date

# the .AddX() are in sequence to get the date object plus seconds, minutes, and hours
$RebootTime = $CurrentTime.AddSeconds($Seconds).AddMinutes($Minutes).AddHours($Hours).ToString("dddd hh:mm:ss tt")

# Calculate the number of seconds in total selected time
$WaitDuration = New-TimeSpan -Seconds $Seconds -Minutes $Minutes -Hours $Hours
$WaitSeconds = $WaitDuration.TotalSeconds

# Print to terminal too for nicess
Write-Host "`nREBOOTING AT $RebootTime`n"

# Start-Job to fork the script block to background so it can proceed with the timer/shutdown even if no interaction with alert box
Start-Job -ScriptBlock {
    # the $using: method lets me adjusst the scope of $RebootTime and get it in this script block
    $RebootTime = $using:RebootTime

    # add the presentation framework in
    Add-Type -AssemblyName PresentationFramework

    # Show an Error/Stop alert box with just an OK button and the message
    [System.Windows.MessageBox]::Show("REBOOTING AT $RebootTime", "FORCE REBOOTING MINUTES AT $RebootTime", 'OK', 'Error')
}

# do the wait
Start-Sleep -Seconds $WaitSeconds

# Add-Type -AssemblyName PresentationFramework
# [System.Windows.MessageBox]::Show("PING WORKING", "$RebootTime", 'OK', 'Error')

# Force reboot with no warning
Restart-Computer -Force