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

# force admin and disable previously scheduled shutdown
# environment
## Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Restart with elevated privileges
    ## added the args string
    Start-Process pwsh.exe -Verb RunAs -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`" $args_string"
    exit
}

Write-Host "args_string: $args_string, wait_minutes: $wait_minutes, total_wait_minutes: $total_wait_minutes, total_wait_seconds: $total_wait_seconds"

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
shutdown -f -r -t ($total_wait_seconds+60) # add a bonus 60 seconds to favor the Start-MpWDOScan 
## do the actual reboot by triggerinmg Start-MpWDOScan
# Start-Sleep -Seconds ($Seconds+60) && Write-Host "Start-MpWDOScan" && webhook "REBOOTAN <@&1369280290203373670>" & # also fork it to the background to be a gremlin
Start-Sleep -Seconds ($total_wait_seconds) && Start-Process powershell -WindowStyle Hidden && webhook "REBOOTAN <@&1369280290203373670>" & # also fork it to the background to be a gremlin
# optional pause
pause