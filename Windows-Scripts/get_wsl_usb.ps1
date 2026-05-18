# llm cancer string that amkes it run as admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}
# Your code goes here
Write-Host "Admin Perms Confirmed!"
Write-Host "Launching WSL"
# lanch in enew window so we can run usbipd commands in the current one
Start-Process pwsh.exe "-NoExit","-Command", "wsl", "-d", "kali-wsl"
# Write-Host "Press Any Key To Continue"
# Clear-Host
Write-Host "Listing usb devices, remember the busid (ex. 1-3) of the device you wish to attach to WSL"
usbipd list
# Write-Host "Press Any Key To Continue"
# $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$BUSID = Read-Host "Enter The BUSID of the USB Device You Wish to Attach to WSL"
Clear-Host
Write-Host "Attaching USB Device with BUSID $BUSID"
usbipd bind --force --busid $BUSID
usbipd attach --wsl --busid $BUSID
Write-Host "USB Device With BUSID $BUSID Has Been Attached to WSL"
Write-Host "Press Any Key To Exit"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit