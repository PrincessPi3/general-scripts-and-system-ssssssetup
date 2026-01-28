if ($args[0]) { $commit_message=($args -join " ") } # if arg0 exists, join all passed args with spaces
else { $commit_message="waypoint" } # or default to "waypoint"

Write-Host "WAYPOINT!`n`tCommit Message: $commit_message`n"
# add and commit
git add .
git commit -m "$commit_message"

Write-Host "`nDone :`"3"