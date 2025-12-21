Param(
    [string]$hosts_file = "subnets.txt",
    [int]$delay_seconds = 120,
    [int]$port = 5555,
    [bool]$ChkDsk = $false
)

# infinitte looppsie
$counter = 1
while($True) {
    Clear-Host # this ig iss the new clear/cls
    
    Write-Host "Scanning $subnet for port $port loop count $counter`n"
    # only show open ports, disable ping host check, output to stdout in greppable format on specified port for all subnets in hosts file
    nmap --open -Pn -oG - -p $port -iL "$hosts_file"
    $counter++

    Write-Host "`nSleeping $delay_seconds Seconds`n"    
    Start-Sleep -Seconds $delay_seconds
}