param (
    [string]$messageContent = "PING!"
)

# get the ping tag
# in discord: \@role_name
$tag = $(Get-Content -Path "$PSScriptRoot\tag.txt")
$messageContent += "`n$tag"

# get webhook url from .\webhook.txt
$webhookUrl = $(Get-Content -Path "$PSScriptRoot\webhook.txt")

$payload = [PSCustomObject]@{
    content = $messageContent
}

# Convert the payload to JSON format
$jsonPayload = $payload | ConvertTo-Json

# Send the POST request to the Discord webhook
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $jsonPayload -ContentType "Application/Json"