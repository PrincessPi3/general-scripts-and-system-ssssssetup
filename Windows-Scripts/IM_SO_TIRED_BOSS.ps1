Param(
    [int]$Seconds = 0,
    [int]$Minutes = 0,
    [int]$Hours = 0
)

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

# Force reboot with no warning
Restart-Computer -Force