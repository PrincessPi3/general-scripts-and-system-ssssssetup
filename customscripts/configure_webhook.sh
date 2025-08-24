#!/bin/bash
finalDir='/usr/share/customscripts'

fix_perms() {
    # fix ownership
    echo -e "\nChanging ownership of $finalDir to $username:$username recursively"
    sudo chown -R $username:$username $finalDir

    # fix perms
    echo -e "\nSetting perms of $finalDir and contents to 775"
    sudo chmod -R 775 $finalDir
}

# ta get da right usermayhaps
if [[ -z $SUDO_USER ]]; then
    echo "Using User $USER"
    username="$USER"
else
    echo "Using User $SUDO_USER" 
    username="$SUDO_USER"
fi

echo -e "\nConfigure Discord Webhook Settings"

if [ -f /tmp/tag.txt ] && [ -f /tmp/webhook.txt ]; then
    existing_webhook=$(cat /tmp/webhook.txt)
    existing_tag=$(cat /tmp/tag.txt)

    echo -e "\nExisting Webhook and Tag found. Using those values unless you enter new ones.\n"
    echo -e "Existing Webhook URL: $existing_webhook"
    echo -e "Existing Tag: $existing_tag\n"

    # move em into place
    sudo mv /tmp/tag.txt $finalDir/tag.txt
    sudo mv /tmp/webhook.txt $finalDir/webhook.txt

    # update permissions
    fix_perms

    exit 0 # exit ok
fi

# get webhook url
echo -e "\nEnter Discord Webhook URL"
read webhook_url

# get tag
echo -e "\nEnter Tag to Notify"
read webhook_tag

# write da files
sudo bash -c "echo '$webhook_url' > $finalDir/webhook.txt"
sudo bash -c "echo '$webhook_tag' > $finalDir/tag.txt"

fix_perms

echo -e "\n\nDone! Restarting shell..."
