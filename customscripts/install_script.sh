#!/bin/bash
# install with
## curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/install_script.sh | sudo "$SHELL" && bash /usr/share/customscripts/configure_webhook.sh && exec "$SHELL"
# install with package install
## curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/install_script.sh | sudo "$SHELL" && bash /usr/share/customscripts/configure_webhook.sh full && exec "$SHELL"
# set -e # make sure da silly thing dont continue when there be errorZ

gitRepo='https://github.com/PrincessPi3/general-scripts-and-system-ssssssetup.git'
tmpDir='/tmp/generalssss'
tmp_customscripts_dir="$tmpDir/customscripts"
finalDir='/usr/share/customscripts'

echo "Using Shell $SHELL"

if [ "$1" == "full" ]; then
    echo "Updating software lists"
    sudo apt update
    echo "Installan my packages"
    sudo apt install gh unattended-upgrades net-tools htop btop iptraf iotop screen byobu wget python3 python3-pip python3-virtualenv python3-setuptools thefuck nginx apache2 wget lynx neovim nmap docker.io zip unzip 7zip net-tools chkrootkit clamav php restic cifs-utils psmisc detox fdupes ripgrep ugrep xxd libimage-exiftool-perl -y
fi

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

# get the existing tag and webhooks if any
if [ -f $finalDir/tag.txt ]; then
    echo "Found existing tag.txt, backing up"
    cp $finalDir/tag.txt /tmp/tag.txt
fi

if [ -f $finalDir/webhook.txt ]; then
echo "Found existing webhook.txt, backing up"
    cp $finalDir/webhook.txt /tmp/webhook.txt
fi

# clean up any exisiting repo dir
if [[ -d "$tmpDir" ]]; then
    echo "Cleaning Up Existing $tmpDir"
    rm -rf "$tmpDir"
fi

# clean up any existing install
if [[ -d "$finalDir" ]]; then
    echo "Cleaning Up Existing $finalDir"
    rm -rf "$finalDir"
fi

# ddownload repo
echo "Cloning Repo $gitRepo"
git clone $gitRepo $tmpDir --single-branch --depth 1

echo "Compiling donut"
gcc -o "$tmp_customscripts_dir/donut" "$tmp_customscripts_dir/donut.c" -lm

# put the customscripts dir into place
echo "Placing in $finalDir"
sudo mv "$tmp_customscripts_dir" "$finalDir"

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
## installer
sudo rm -f "$finalDir/install_script.sh"

## git repo
sudo rm -rf "$tmpDir"

## donut c file
rm -f "$tmp_customscripts_dir/donut.c"
# sudo apt autoremove -y

echo "Done with first stage"