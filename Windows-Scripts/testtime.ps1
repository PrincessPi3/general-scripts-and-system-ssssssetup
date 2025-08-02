# usage:
#   testtime "some powershell command string"
param([string] $cmd)
$start=$(get-date -uformat "%s")
invoke-expression "$cmd"
$end=$(get-date -uformat "%s")
echo "`n`ntime: $($end - $start)`n`n"