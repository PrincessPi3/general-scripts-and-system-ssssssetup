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

echo -e "\nConfigure Discord Webhook Settings"

# get webhook url
echo -e "\nEnter Discord Webhook URL"
read webhook_url

# get tag
echo -e "\nEnter Tag to Notify"
read webhook_tag

# write da files
sudo bash -c "echo '$webhook_url' > $finalDir/webhook.txt"
sudo bash -c "echo '$webhook_tag' > $finalDir/tag.txt"

# fix ownership
echo -e "\nChanging ownership of $finalDir to $username:$username recursively"
sudo chown -R $username:$username $finalDir

# fix perms
echo -e "\nSetting perms of $finalDir and contents to 775"
sudo chmod -R 775 $finalDir

echo -e "\n\nDone! Restart shell:\n\texec \"\$SHELL\"\n"
