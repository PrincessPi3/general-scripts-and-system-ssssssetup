# todo: sanity checks for if x wsl is installed and x v2, if x usbipd is installed, if the user is running powershell >-7
# x if wsl is not installed, install it
# x if usbipd is not installed, install it
# if wsl is not version 2, upgrade it

# :pope: may work
#Requires -RunAsAdministrator

# llm cancer string that amkes it run as admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# detach and unbind all devices and exit
if($args[0] -eq "detach") {
    Write-Host "Detaching and Unbinding all USB devices from WSL"
    usbipd detach --all
    usbipd unbind --all
    Write-Host "All USB devices have been detached and unbound from WSL"
    Write-Host "Press Any Key To Exit"
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# list devices and exit
if ($args[0] -eq "list") {
    Write-Host "Listing USB devices attached to WSL"
    usbipd list

    Write-Host "Press Any Key To Exit"
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# help bs
if ($args[0] -eq "help") {
    Write-Host "Usage: .\get_wsl_usb.ps1 [options]"
    Write-Host "Options:"
    Write-Host "  attach   Attach a USB device to WSL (default action if no options are provided)"
    Write-Host "  detach   Detach and unbind all USB devices from WSL"
    Write-Host "  list     List USB devices attached to WSL"
    Write-Host "  help     Display this help message"
    Write-Host "If no options are provided, the script will list USB devices and allow you to attach one to WSL."
    Write-Host "Press Any Key To Exit"
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# now sanity/env checks
## check if wsl installed is version 2, if not upgrade it it
function Check-WSLVersion {
    <#
    .SYNOPSIS
    Check if WSL is version 2 and upgrade if necessary.
    
    .DESCRIPTION
    This function checks the installed WSL version and upgrades to WSL 2 if needed.
    #>
    
    # Get WSL status
    $wslStatus = wsl --status 2>&1
    
    # Check if WSL 2 is available (look for WSL 2 in status output)
    if ($wslStatus -match "WSL version:\s+\d") {
        if ($wslStatus -match "Default distribution version:\s+2") {
            Write-Host "WSL 2 is already installed and set as default."
            return $true
        }
        else {
            Write-Host "WSL 1 detected. Attempting to upgrade to WSL 2..."
            try {
                wsl --update
                Write-Host "WSL has been updated. Please restart your computer and run this script again."
                return $false
            }
            catch {
                Write-Host "Error updating WSL: $_"
                return $false
            }
        }
    }
    else {
        # Fallback: try to get list of distributions
        $wslList = wsl --list -v 2>&1
        if ($wslList -match "VERSION\s+2") {
            Write-Host "WSL 2 detected."
            return $true
        }
        elseif ($wslList -match "VERSION\s+1") {
            Write-Host "WSL 1 detected. Upgrading to WSL 2..."
            try {
                $distros = $wslList | Where-Object { $_ -match "^[^*]" } | ForEach-Object { ($_ -split '\s+')[0] } | Where-Object { $_ -and $_ -ne "NAME" }
                foreach ($distro in $distros) {
                    Write-Host "Upgrading $distro to WSL 2..."
                    wsl --set-version $distro 2
                }
                Write-Host "Distros have been upgraded to WSL 2."
                return $true
            }
            catch {
                Write-Host "Error upgrading WSL: $_"
                return $false
            }
        }
    }
    
    return $false
}

## if wsl not installed, install it
if (-not (Get-Command wsl -ErrorAction SilentlyContinue)) {
    Write-Host "WSL is not installed. Installing WSL..."
    wsl --install
    Write-Host "WSL has been installed. Please restart your computer and run this script again."
    exit
}

## Check WSL version and upgrade if needed
# if (-not (Check-WSLVersion)) {
#     Write-Host "WSL upgrade required. Please restart your computer and run this script again."
# }

# do the wsl version check and upgrade if needed before we do anything else
if (-not (Get-Command usbipd -ErrorAction SilentlyContinue)) {
    Write-Host "usbipd is not installed. Installing usbipd..."
    winget install usbipd
    Write-Host "usbipd has been installed."
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