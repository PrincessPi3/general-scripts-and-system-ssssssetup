# usage
## sync_media [NUKE]

# $media_viewer_dir="C:\Users\human\OneDrive\Documents\Git\Media-Viewer"
$media_viewer_dir_wsl="/mnt/c/Users/human/OneDrive/Documents/Git/Media-Viewer"

# select for nuke mode
if($args[0] -eq "NUKE") {
    Write-Host "`nNUKE MODE ACTIVATED`n"
    $nuke = $True
} else {
    Write-Host "`nNormal Mode Activated`n"
    $nuke = $False  
}

Write-Host "`nSillyfillyy synching media loleen`n"

# do da synchiedink
Write-Host "`n`bPERFORMING THE DILDOSYNC`n`n"
# wsl bash $media_viewer_dir_wsl/copy_local_wsl.sh
if($nuke) {
    Write-Host "`nrunning sync with NUKE`n"
    wsl bash $media_viewer_dir_wsl/dildo_new_full_sync_total.sh NUKE
} else {
    Write-Host "`nNormal sync`n"
    wsl bash $media_viewer_dir_wsl/dildo_new_full_sync_total.sh
}

# remote esp-idf
Write-Host "`nRunning esp-idf-tools update`n"
if($nuke) {
    Write-Host "`nNUKING esp-idf-tools update`n"
    ssh pi3 "bash /home/princesspi/esp/esp-idf-tools/esp-idf-tools-cmd.sh n"
} else {
    Write-Host "`nNormal esp-idf-tools update`n"
    ssh pi3 "bash /home/princesspi/esp/esp-idf-tools/esp-idf-tools-cmd.sh"
}

Write-Host "`naahm done bein a sillyfilly fro noew`n"
