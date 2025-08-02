#!/bin/bash
# set -e # make sure da silly thing dont continue when there be errorZ

gitRepo='https://github.com/PrincessPi3/general-scripts-and-system-ssssssetup.git'
tmpDir='/tmp/customscripts'
finalDir='/usr/share/customscripts'

echo "Updating software lists"
sudo apt update

echo "Installan my packages"
sudo apt install gh net-tools htop btop iptraf iotop screen byobu wget python3 python3-pip python3-virtualenv python3-setuptools thefuck nginx wget lynx neovim nmap -y

echo "Using Shell $SHELL"

# ta get da right usermayhaps
if [[ -z $SUDO_USER ]]; then
    echo "Using User $USER"
    username="$USER"
else
    echo "Using User $SUDO_USER" 
    username="$SUDO_USER"
fi

# figure oot da sehell
if [[ "$SHELL" =~ bash$ ]]; then
    rcfile="/home/$username/.bashrc"
elif [[ "$SHELL" =~ zsh$ ]]; then
    rcfile="/home/$username/.zshrc"
else
    echo -e "Die: Unsupported Shell";
    exit
fi

# clean up any existing install
if [[ -d "$tmpDir" ]]; then
    echo "Cleaning Up Existing $tmpDir"
    rm -rf "$tmpDir"
fi

if [[ -d "$finalDir" ]]; then
    echo "Cleaning Up Existing $finalDir"
    rm -rf "$finalDir"
fi

echo "Cloning Repo $gitRepo"
git clone $gitRepo $tmpDir --single-branch --depth 1

echo "Placing in $finalDir"
mv "$tmpDir/customscripts" "$finalDir"

echo "Changing ownership of $finalDir to $username:$username recursively"
chown -R $username:$username "$finalDir"

echo "Setting perms of $finalDir and contents to 775"
chmod -R 775 "$finalDir"

grep -q $finalDir $rcfile
pathgrep=$?

if [ $pathgrep -eq 0 ]; then
    echo "$finalDir Already in \$PATH Skipping"
else
    echo "Adding $finalDir to $username's \$PATH by Appending to $rcfile"
    echo -e "\n\n# automatically added by customscripts installer\nexport PATH=\"\$PATH:$finalDir\"" >> "$rcfile"
fi

# configure webhook
# echo "Enter Discord Webhook URL"
# read url
# echo "Enter Tag to Notify"
# read tag
# sudo bash -c "echo '$url' > /usr/share/customscripts/webhook.txt"
# sudo bash -c "echo '$tag' > /usr/share/customscripts/tag.txt"

echo -e "\n\nDone! Restart shell:\n\texec \"\$SHELL\"\n\n"