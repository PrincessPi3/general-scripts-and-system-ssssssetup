#!/bin/bash
# install with
## curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/install_script.sh?nocache=$RANDOM | sudo "$SHELL" && bash /usr/share/customscripts/configure_webhook.sh && exec "$SHELL"
# set -e # make sure da silly thing dont continue when there be errorZ

gitRepo='https://github.com/PrincessPi3/general-scripts-and-system-ssssssetup.git'
tmpDir='/tmp/customscripts'
finalDir='/usr/share/customscripts'

# echo "Updating software lists"
# sudo apt update

# echo "Installan my packages"
# sudo apt install gh net-tools htop btop iptraf iotop screen byobu wget python3 python3-pip python3-virtualenv python3-setuptools thefuck nginx wget lynx neovim nmap -y

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

# clean up any exisiting repo dir
if [[ -d "$finalDir" ]]; then
    echo "Cleaning Up Existing $finalDir"
    rm -rf "$finalDir"
fi

# ddownload repo
echo "Cloning Repo $gitRepo"
git clone $gitRepo $tmpDir --single-branch --depth 1

# put the customscripts dir into place
echo "Placing in $finalDir"
sudo mv "$tmpDir/customscripts" "$finalDir"

# fix ownership
echo "Changing ownership of $finalDir to $username:$username recursively"
sudo chown -R $username:$username "$finalDir"

# fix perms
echo "Setting perms of $finalDir and contents to 775"
sudo chmod -R 775 "$finalDir"

# check if $finalDir is in $rcfile
grep -q $finalDir $rcfile
pathgrep=$?

if [ $pathgrep -eq 0 ]; then
    echo "$finalDir Already in \$PATH Skipping"
else
    echo "Adding $finalDir to $username's \$PATH by Appending to $rcfile"
    echo -e "\n\n# automatically added by customscripts installer\nexport PATH=\"\$PATH:$finalDir\"" >> "$rcfile"
fi

# cleanup
sudo rm -f $finalDir/install_script.sh
# sudo apt autoremove -y

echo "Done with first stage"