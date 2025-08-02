param (
    [Parameter(Mandatory=$true)]
    [string]$infile
)

Invoke-Expression "$PSScriptRoot\winhash.ps1 $infile SHA512"
