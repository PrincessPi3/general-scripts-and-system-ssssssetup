# usage
## sync_media [NUKE]

$media_viewer_dir="C:\Users\human\OneDrive\Documents\Git\Media-Viewer"
$media_viewer_dir_wsl="/mnt/c/Users/human/OneDrive/Documents/Git/Media-Viewer/"

# select for nuke mode
if($args[0] -eq "NUKE") {
    Write-Host "`nNUKE MODE ACTIVATED`n"
    $nuke = $True
} else {
    Write-Host "`nNormal Mode Activated`n"
    $nuke = $False  
}

Write-Host "`nSillyfillyy synching media loleen`n"

Write-Host "`nChanging directory to $media_viewer_dir`n"
Set-Location "$media_viewer_dir"

# get da synciedink
Write-Host "`nSyncing`n"
gitsync
Write-Host "`nSyncing Again`n"
gitsync

# do da synchiedink
Write-Host "`nDoing the syncy dink`n"
# wsl -d kali-wsl "\$(whoami) \$(uname -a)" # debug
if($nuke) {
    Write-Host "`nNUKING media loleen sync`n"
    wsl bash $media_viewer_dir_wsl/full_sync_normalization_wsl.sh byfn
} else {
    Write-Host "`nNormal media loleen sync`n"
    wsl bash $media_viewer_dir_wsl/full_sync_normalization_wsl.sh byf
}

# normieize media
Write-Host "`nNormalizing favorites`n"
ssh pi3 "bash /var/www/html/Media-Viewer/normalize_favorites.sh"

# remote esp-idf
Write-Host "`nRunning esp-idf-tools update`n"
if($nuke) {
    Write-Host "`nNUKING esp-idf-tools update`n"
    ssh pi3 "bash /home/princesspi/esp/esp-idf-tools/esp-idf-tools-cmd.sh n"
} else {
    Write-Host "`nNormal esp-idf-tools update`n"
    ssh pi3 "bash /home/princesspi/esp/esp-idf-tools/esp-idf-tools-cmd.sh"
}

# reboot pi3 to apply updates
if($nuke) {
    Write-Host "`nNUKING reboot of pi3 to apply updates`n"
    ssh pi3 "sudo shutdown -r +10 'Rebooting in 10 minutes to apply updates'"
} else {
    Write-Host "`nSkipping remote reboot`n"
}

# do more sync at enddy to maek syre it goodywoo
Write-Host "`nSyncing finaly`n"
gitsync
Write-Host "`nSyncing finaly again`n"
gitsync

Write-Host "`naahm done bein a sillyfilly fro noew`n"
