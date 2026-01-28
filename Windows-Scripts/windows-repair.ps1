# Usage:
#   Download to $env:USERPROFILE\Downloads (user's Downloads folder)
#     https://raw.githubusercontent.com/human/Windows-Scripts/main/windows-repair.ps1
#   Open PowerShell as Administrator
#     win+x
#     alt+a
#     alt+y
#   Run:
#     powershell.exe -ExecutionPolicy Bypass -File $env:USERPROFILE\Downloads\windows-repair.ps1

# Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Restart with elevated privileges
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`""
    exit
}

Write-Host "`nFIXING WINDOWS FULL STYLE`n"

Write-Host "ABORTING ANY SCHEDULED SHUTDOWN"
shutdown /a # cmd abort scheduled shutdowns

Write-Host "RUNNING WINDOWS MALICIOUS SOFTWARE REMOVAL TOOL (mrt)"
mrt # cmd malicious software removal tool

Write-Host "RUNNING SYSTEM FILE CHECKER (sfc)"
sfc /scannow # cmd system file checker, retreives and replaces bad system files

Write-Host "RUNNING DISM"
DISM /Online /Cleanup-Image /RestoreHealth # powershell checks image and replaces bad files

Write-Host "SCHEDULING OFFLINE CHECK DISK AND REPAIR OF C: (chkdsk)"
Write-Host y | chkdsk /f /r C: # cmd checks C drive after reboot to waste time and fix errors (noninteractive)

Write-Host "SCHEDULING WINDOWS DEFENDER OFFLINE SCAN"
Start-MpWDOScan # powershell starts Windows Defender Offline Scan after reboot

Write-Host "`nREBOOTING IN 5 MINUTES`n"
shutdown /r /t 300