#!/bin/bash
# install with
## curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/install_script.sh | sudo "$SHELL" && bash /usr/share/customscripts/configure_webhook.sh && exec "$SHELL"
# install with package install
## script=/tmp/install_script.sh && curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/install_script.sh > $script && chmod +x $script && sudo $SHELL -c "$script full" && $SHELL /usr/share/customscripts/configure_webhook.sh full && exec "$SHELL"
# set -e # make sure da silly thing dont continue when there be errorZ

gitRepo='https://github.com/PrincessPi3/general-scripts-and-system-ssssssetup.git'
tmpDir='/tmp/generalssss'
tmp_customscripts_dir="$tmpDir/customscripts"
finalDir='/usr/share/customscripts'
packages="apache2 nginx build-essential cowsay iotop iptraf-ng gh btop screen byobu thefuck wget lynx zip unzip 7zip xz-utils gzip net-tools clamav php restic cifs-utils detox fdupes ripgrep avahi-daemon libnss-mdns xxd xrdp libimage-exiftool-perl kali-tools-hardware kali-tools-crypto-stego kali-tools-fuzzing kali-tools-bluetooth kali-tools-rfid kali-tools-sdr kali-tools-voip kali-tools-802-11 kali-tools-forensics samba"

echo "Using Shell $SHELL"

if [ ! -z "$1" ]; then
    echo "Updating software lists"
    sudo apt update
    echo "Doin full-upgrade"
    sudo apt full-upgrade -y
    echo "Installan my packages"
    sudo bash -c "apt install $packages -y"
    echo "cleanan upps"
    sudo apt autoremove -y
    # echo "rebootan before run againnn (in 1 minute)"
    # sudo shutdown -r +1
fi

# ta get da right usermayhaps
if [[ -z $SUDO_USER ]]; then
    echo "Using User $USER"
    username="$USER"
else
    echo "Using User $SUDO_USER" 
    username="$SUDO_USER"
fi

# home dir
userhome=/home/$username

# figure oot da sehell
if [[ "$SHELL" =~ bash$ ]]; then
    rcfile="$userhome/.bashrc"
elif [[ "$SHELL" =~ zsh$ ]]; then
    rcfile="$userhome/.zshrc"
else
    echo -e "Die: Unsupported Shell";
    exit 1
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

# install pishrink if not there
if [ ! -f /usr/local/bin/pishrink ]; then
    wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
    mv pishrink.sh pishrink
    chmod +x pishrink
    sudo mv pishrink /usr/local/bin
fi

# install ble.sh if not there
if [ ! -d $userhome/.local/share/blesh ]; then
    # install ble.sh
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
    make -C ble.sh install PREFIX=$userhome/.local
    echo '# ble.sh' >> $rcfile
    echo "source -- $userhome/.local/share/blesh/ble.sh" >> $rcfile
    source $rcfile
    exec "$SHELL"
fi

# appeend thefuck to rcfile if not present
grep -q thefuck $rcfile
thefuck_present=$?
if [ $thefuck_present -ne 0 ]; then 
    echo -e "# thefuck\neval \$(thefuck --alias fuck)" >> $rcfile
fi

# copy rice
mv $tmpDir/rice /home/$username/

# cleanup
## installer
sudo rm -f "$finalDir/install_script.sh"
rm /tmp/install_script.sh
## git repo
sudo rm -rf "$tmpDir"
## donut c file
rm -f "$tmp_customscripts_dir/donut.c"

if [ ! -z "$1" ]; then
    sudo apt autoremove -y
fi

echo "Done with first stage"