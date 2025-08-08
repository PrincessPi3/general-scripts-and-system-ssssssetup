#!/bin/bash
# get webhook url
echo "Enter Discord Webhook URL"
read url

# get tag
echo "Enter Tag to Notify"
read tag

# write da files
sudo bash -c "echo '$url' > /usr/share/customscripts/webhook.txt"
sudo bash -c "echo '$tag' > /usr/share/customscripts/tag.txt"

# fix ownership
echo "Changing ownership of $finalDir to $username:$username recursively"
sudo chown -R $username:$username "$finalDir"

# fix perms
echo "Setting perms of $finalDir and contents to 775"
sudo chmod -R 775 "$finalDir"