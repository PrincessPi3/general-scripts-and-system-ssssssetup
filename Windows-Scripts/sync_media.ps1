$media_viewer_dir="C:\Users\human\OneDrive\Documents\Git\Media-Viewer"
Set-Location "$media_viewer_dir"

Write-Host "`nSillyfillyy synching media loleen`n"

Write-Host "`nChanging directory to Media-Viewer`n"
cd "$media_viewer_dir"

# get da synciedink
Write-Host "`nSyncing`n"
gitsync
Write-Host "`nSyncing Again`n"
gitsync

# do da synchiedink
Write-Host "`nDoing the syncy dink`n"
wsl bash full_sync_normalization_wsl.sh bfy

# normieize media
Write-Host "`nNormalizing favorites`n"
ssh pi3 "bash /var/www/html/Media-Viewer/normalize_favorites.sh"

# remote esp-idf
Write-Host "`nRunning esp-idf-tools update`n"
ssh pi3 "bash /home/princesspi/esp/esp-idf-tools/esp-idf-tools-cmd.sh"

# remote backup
Write-Host "`nRunning restic backup`n"
ssh pi3 "sudo bash /home/princesspi/.restic/restic_backup.sh"

# do more sync at enddy to maek syre it goodywoo
Write-Host "`nSyncing finaly`n"
gitsync
Write-Host "`nSyncing finaly again`n"
gitsync

Write-Host "`naahm done bein a sillyfilly fro noew`n"
