
# Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Restart with elevated privileges
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`""
    exit
}

Write-Host "FIXING WINDOWS FULL STYLE"

Write-Host "ABORTING ANY SCHEDULED SHUTDOWN"
shutdown /a # cmd abort scheduled shutdowns

Write-Host "RUNNING WINDOWS MALICIOUS SOFTWARE REMOVAL TOOL (mrt)"
mrt # cmd malicious software removal tool

Write-Host "RUNNING SYSTEM FILE CHECKER (sfc)"
sfc /scannow # cmd system file checker, retreives and replaces bad system files

Write-Host "RUNNING DISM"
DISM /Online /Cleanup-Image /RestoreHealth # powershell checks image and replaces bad files

Write-Host "SCHEDULING OFFLINE CHECK DISK OF C: (chkdsk)"
chkdsk /r C: # cmd checks C drive after reboot to waste time and fix errors

Write-Host "SCHEDULING WINDOWS DEFENDER OFFLINE SCAN"
Start-MpWDOScan # powershell starts Windows Defender Offline Scan after reboot

Write-Host "REBOOTING IN 5 MINUTES"
shutdown /r /t 300