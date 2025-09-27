# usage force_me_off -Hours <int> -Minutes <int> -GraceMinutes <int>
# default one hour, zero minutes, one grace minute
param ( 
    [int]$Hours,
    [int]$Minutes,
    [int]$GraceMinutes
)

# handle defaULTS, not using normal param() method because wasnt workan right
## !skillissue
if($Hours -eq $null) {
    $Hours = 1
} elseif($Minutes -eq $null) {
    $Minutes = 0
} elseif ($GraceMinutes) {
    $GraceMinutes = 1
}

# some calcs
$wait_minutes = (($Hours*60)+$Minutes)
$total_wait_minutes = ($wait_minutes+$GraceMinutes)
$total_wait_seconds = ($total_wait_minutes*60)
$reboot_time = $((Get-Date).AddHours($Hours).AddMinutes($Minutes + $GraceMinutes).ToString("hh:mm:ss tt"))

$args_string = "-Hours $Hours -Minutes $Minutes -GraceMinutes $GraceMinutes"
# echo $args_string
# exit

# function ForceOff {
#     # time wasters
#     ## checks C drive after reboot to waste time and fix errors
#     ## chkdsk /r C: # as admin
#     chkdsk /r C:
#     pause # pause for clarity
# 
#     # Do the sleep
#     Start-Sleep -Seconds $total_wait_seconds
# 
#     # do reboot
#     ## schedule shutdown
#     ## redundant but also for warnings
#     ### reboot (-r) forced (-t) in seconds (-t)
#     shutdown -r -f -t ($total_wait_seconds+($GraceMinutes*60)) # 10 second bonus to defer to Start-MpWDOScan
#     ## Start Windows Defender Offline Scan
#     ## wastes time
#     ## does the actual reboot
#     Start-MpWDOScan
# }

# force admin and disable previously scheduled shutdown
# environment
## Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Restart with elevated privileges
    Start-Process pwsh.exe -Verb RunAs -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" $args_string"
    exit
}

Write-Host "args: $args_string, wait_minutes: $wait_minutes, total_wait_minutes: $total_wait_minutes, total_wait_seconds: $total_wait_seconds"
# Write-Host "-File `"$($MyInvocation.MyCommand.Path)`" $args_string"

# cleanup
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
## make it do it noninteractively with echo y
## echo specifically seems needeed
echo y | chkdsk /r C:

# shutdown tasks
## schedule normal shutdown as backup and for warnings
shutdown -f -r -t ($total_wait_seconds+10) # 10 second bonus to defer to Start-MpWDOScan
## do the actual reboot by triggerinmg Start-MpWDOScan
# Start-Sleep -Seconds ($Seconds+60) && Write-Host "Start-MpWDOScan" && webhook "REBOOTAN <@&1369280290203373670>" & # also fork it to the background to be a gremlin
Start-Sleep -Seconds ($total_wait_seconds+60) && Start-Process pwsh && webhook "REBOOTAN <@&1369280290203373670>" & # also fork it to the background to be a gremlin
pause

# $test_background_scriptblock = {
#     Write-Host $total_wait_seconds
#     Start-Sleep -Seconds 5
#     Start-Process "pwsh.exe" -Verb RunAs
# }

# $command_string = "-NoExit", "-WindowStyle", "Hidden", "-Command", "& { $background_scriptblock }"
# $test_command_string = "-Command ", "& { $test_background_scriptblock }"

# Write-Host $test_command_string

# send it to background!


# Start-Process pwsh -ArgumentList $command_string -Verb RunAs
# Start-Process -FilePath "pwsh.exe" -ArgumentList $test_command_string -Verb RunAs