#!/bin/bash
# install without upfate and package install
## script=/tmp/install_script.sh && curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/install_script.sh > $script && chmod +x $script && $SHELL -c "$script" && $SHELL /usr/share/customscripts/configure_webhook.sh full && exec $SHELL
# install with package install
## script=/tmp/install_script.sh && curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/install_script.sh > $script && chmod +x $script && $SHELL -c "$script full" && $SHELL /usr/share/customscripts/configure_webhook.sh full && exec $SHELL

# set -e # make sure da silly thing dont continue when there be errorZ

# configs
gitRepo='https://github.com/PrincessPi3/general-scripts-and-system-ssssssetup.git'
tmpDir='/tmp/generalssss'
tmp_customscripts_dir="$tmpDir/customscripts"
finalDir='/usr/share/customscripts'
packages="7zip apache2 argon2 avahi-daemon btop build-essential byobu cargo cifs-utils clamav cmake cowsay cracklib-runtime detox docker.io exiftool fdupes gcc-arm-none-eabi grc gzip iotop iptraf-ng jq kpartx libimage-exiftool-perl libnss-mdns libnewlib-arm-none-eabi librust-git2+openssl-probe-dev libstdc++-arm-none-eabi-newlib locales lynx net-tools nginx openssl php polygen polygen-data procps python3 resolvconf restic ripgrep samba screen seclists snapd thefuck unzip wget xrdp xxd xz-utils zip"
# packages="grc kpartx openssl cracklib-runtime argon2 jq polygen polygen-data apache2 seclists cmake locales python3 build-essential gcc-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib librust-git2+openssl-probe-dev cargo nginx build-essential cowsay iotop iptraf-ng btop screen byobu thefuck wget lynx zip unzip 7zip xz-utils gzip net-tools clamav php restic cifs-utils detox fdupes ripgrep avahi-daemon libnss-mdns xxd xrdp libimage-exiftool-perl kali-tools-hardware kali-tools-crypto-stego kali-tools-fuzzing kali-tools-bluetooth kali-tools-rfid kali-tools-sdr kali-tools-voip kali-tools-802-11 kali-tools-forensics samba procps snapd"

echo -e "\nSTARTING!\n\tUsing Shell $SHELL\n"

# ta get da right usermayhaps
if [[ -z $SUDO_USER ]]; then
    echo -e "\nUsing User $USER\n"
    username="$USER"
else
    echo -n "\nUsing User $SUDO_USER\n" 
    username="$SUDO_USER"
fi

# home dir
userhome=/home/$username

# figure oot da sehell
# if [[ "$SHELL" =~ bash$ ]]; then
rcfile="$userhome/.bashrc"
# elif [[ "$SHELL" =~ zsh$ ]]; then
#     rcfile="$userhome/.zshrc"
# else
#     echo -e "Die: Unsupported Shell";
#     exit 1
# fi

echo -e "\nusing rcfile $rcfile\n"

if [ ! -z "$1" ]; then
    echo -e "\nFULL MODE SELECTED FULL UPGRADE AND INSTALL PACKAGES!\n"
    # update and upgrade
    echo -e "\nUpdating software lists\n"
    sudo apt update
    echo -e "\nDoin full-upgrade\n"
    sudo apt full-upgrade -y

    echo "installan packages"
    echo -e "\nInstallan my packages\n"
    sudo bash -c "apt install $packages -y"
    source $rcfile
    # dotnet conditional install
    if [ ! $(which dotnet) ]; then
        echo -e "\ndotnet not found, installing\n"
        wget https://dot.net/v1/dotnet-install.sh -O /tmp/dotnet-install.sh
        chmod +x /tmp/dotnet-install.sh
        /tmp/dotnet-install.sh --channel LTS
        echo -e "## dotnet\nPATH=\$PATH:$userhome/.dotnet:$userhome/.dotnet/tools" >> $rcfile
        source $rcfile
    else
        echo -e "\ndotnet installed, skipping install of repo\n"
    fi
    ## dotnet
    ### haveibeenpwned-downloader
    if [ ! $(which haveibeenpwned-downloader) ]; then
        echo -e "\nhaveibeenpwned-downloader not found, installing with dotnet\n"
        dotnet tool install --global haveibeenpwned-downloader
    else
        echo -e "\nhaveibeenpwned-downloader installed, skipping install\n"
    fi
    # homebrew
    if [ ! $(which brew) ]; then
        ## install homebrew
        echo -e "\nlinuxbrew not found, installing\n"
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        ### add to rcfile
        # echo "# linuxbrew (homebrew/brew)" >> $rcfile
        # echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> $rcfile
        # source $rcfile
    else
        echo -e "\nlinuxbrew installed, skipping install\n"
    fi
    ### install ponysay
    if [ ! $(which ponysay) ]; then
        echo -e "\nponysay not fonud, installiing\n"
        brew install ponysay
        # echo -e "# ponysay fix\nexport PYTHONWARNINGS=ignore::SyntaxWarning" >> $rcfile
    else
        echo -e "\nponysay already installed, skipping\n"
    fi
    # cargo
    ## oniux
    echo -e "\nINSTALLIN TOR ONIUX\n"
    if [ -f /usr/local/bin/oniux ]; then
        echo -e "\nexisting oniux found, skipping\n"
    else
        echo -e "\nexisting oniux not found, installing\n"
        ### from main 
        echo -e "\ndownloadin oniux code from main branch\n"
        ##### niec fast downdoot
        git clone --recursive --single-branch --depth 1 -b main https://gitlab.torproject.org/tpo/core/oniux /tmp/oniux
        cd /tmp/oniux
        ### build it
        echo -e "\nbuildin and installin oniux\n"
        cargo build
        ### move it somewhere in PATH
        sudo mv ./target/debug/oniux /usr/local/bin/
        # cleanup
        echo -e "\ncleanan upps\n"
        sudo apt autoremove -y
    fi

else
    echo -e "\nskipping package install\n"
fi

# get the existing tag and webhooks if any
if [ -f $finalDir/tag.txt ]; then
    echo -e "\nFound existing tag.txt, backing up\n"
    cp $finalDir/tag.txt /tmp/tag.txt
else
    echo -e "\nno existing tag.txt, skipping backup of it\n"
fi

# backup webhook if present
if [ -f $finalDir/webhook.txt ]; then
    echo -e "\nFound existing webhook.txt, backing up\n"
    cp $finalDir/webhook.txt /tmp/webhook.txt
else
    echo -e "\nno existing webhook.txt, skipping backup of it\n"
fi

# clean up any exisiting repo dir
if [[ -d "$tmpDir" ]]; then
    echo "\nCleaning Up Existing $tmpDir\n"
    rm -rf "$tmpDir"
else
    echo -e "\n$tmpDir not found, skipping deleting it\n"
fi

# clean up any existing install
if [[ -d "$finalDir" ]]; then
    echo -e "\nCleaning Up Existing $finalDir\n"
    sudo rm -rf "$finalDir"
else
    echo -e "\n$finalDir not found, will create\n"
fi

# ddownload repo
echo -e "\nCloning Repo $gitRepo\n"
git clone $gitRepo $tmpDir --single-branch --depth 1

# donut
echo -e "\nCompiling donut\n"
gcc -o "$tmp_customscripts_dir/donut" "$tmp_customscripts_dir/donut.c" -lm 2>/dev/null

# put the customscripts dir into place
echo -e "\nPlacing in $finalDir\n"
sudo mv "$tmp_customscripts_dir" "$finalDir"

# fix ownership
echo -e "\nChanging ownership of $finalDir and $userhome/Rice to $username:$username recursively\n"
sudo chown -R $username:$username "$finalDir"
sudo chown -R $username:$username $userhome/Rice

# fix perms
echo -e "\nSetting perms of $finalDir and contents to 775\n"
sudo chmod -R 775 "$finalDir"

# check if $finalDir is in $rcfile
grep -q $finalDir $rcfile
pathgrep=$?
if [ $pathgrep -eq 0 ]; then
    echo -e "\n$finalDir Already in \$PATH Skipping Append\n"
else
    echo -e "\nAdding $finalDir to $username's \$PATH by Appending to $rcfile\n"
    echo -e "\n\n# automatically added by customscripts installer\nexport PATH=\"\$PATH:$finalDir\"" >> "$rcfile"
fi

# install pishrink if not there
if [ ! -f /usr/local/bin/pishrink ]; then
    echo -e "\npishrink not found, installing\n"
    wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
    mv pishrink.sh pishrink
    chmod +x pishrink
    sudo mv pishrink /usr/local/bin
else
    echo -e "\nPishrink already installed, skipping\n"
fi

# install ble.sh if not there
if [ ! -d $userhome/.local/share/blesh ]; then
    # install ble.sh
    echo -e "\nble.sh not found, installing\n"
    cd /tmp
    git clone --recursive --depth 1 --shallow-submodules --single-branch -b master https://github.com/akinomyoga/ble.sh.git
    make -C ble.sh install PREFIX=~/.local
    echo '# ble.sh' >> $rcfile
    echo "source -- ~/.local/share/blesh/ble.sh" >> $rcfile
    # source $rcfile
    # exec "$SHELL"
else
    echo -e "\nble.sh already installed, skippping\n"
fi

# appeend thefuck to rcfile if not present
grep -q thefuck $rcfile
thefuck_present=$?
if [ $thefuck_present -ne 0 ]; then 
    echo -e "\nthefuck alias not fonud in $rcfile, adding\n"
    echo -e "# thefuck\neval \$(thefuck --alias fuck)" >> $rcfile
    source $rcfile
else
    echo -e "\nthefuck is already in $rcfile, skipping\n"
fi

# copy rice if not present
if [ ! -d $userhome/Rice ]; then
    echo -e "\n$userhome/Rice not found, adding\n"
    mv $tmpDir/Rice $userhome
else
    echo -e "\nRice found not copying again\n"
fi

# cleanup
echo -e "\ncleaning up temp files\n"
## installer
sudo rm -f "$finalDir/install_script.sh"
rm /tmp/install_script.sh
## git repo
sudo rm -rf "$tmpDir"
## donut c file
rm -f "$tmp_customscripts_dir/donut.c"

if [ ! -z "$1" ]; then
    echo -e "cleaning up apt"
    sudo apt autoremove -y
    # echo -e "\nrebooting in 3 minutes\n"
    # sudo shutdown -r +3
fi

echo -e "\nDone with first stage\n"