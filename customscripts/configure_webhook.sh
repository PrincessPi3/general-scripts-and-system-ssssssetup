#!/bin/bash
finalDir='/usr/share/customscripts'

# ta get da right usermayhaps
if [[ -z $SUDO_USER ]]; then
    echo "Using User $USER"
    username="$USER"
else
    echo "Using User $SUDO_USER" 
    username="$SUDO_USER"
fi

# get webhook url
echo "Enter Discord Webhook URL"
read webhook_url

# get tag
echo "Enter Tag to Notify"
read webhook_tag

# write da files
sudo bash -c "echo '$webhook_url' > $finalDir/webhook.txt"
sudo bash -c "echo '$webhook_tag' > $finalDir/tag.txt"

# fix ownership
echo "Changing ownership of $finalDir to $username:$username recursively"
sudo chown -R $username:$username $finalDir

# fix perms
echo "Setting perms of $finalDir and contents to 775"
sudo chmod -R 775 $finalDir