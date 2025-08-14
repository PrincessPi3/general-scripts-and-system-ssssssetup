#!/bin/bash
# installs the Alpha AWUS036ACH on kali linux
# has some slowdowns and pauses to work around a stupid issuie i have
git_dir='/tmp/rtl8812au'
git_repo='https://github.com/aircrack-ng/rtl8812au.git'

# make sure environment is up to date
sudo apt update
# sudo apt upgrade -y
# sudo apt dist-upgrade -y

# install dkms and rtl dkms
sudo apt-get install dkms -y
# sleep 10 # stupid_error
sudo apt-get install realtek-rtl88xxau-dkms -y

# download the code
# catch any submodules, only clone one branch, only download with two jobs to save stress # stupid_error
git clone --recursive --single-branch --jobs 7 $git_repo $git_dir
# sleep 10 # stupid_error

# build it
cd $git_dir # enter the dir
make # compile it
# sleep 10 # stupid_error

# install the module
sudo make install
sleep 10 # stupid_error

# cleanup
cd ~
rm -rf $git_dir
# sleep 10 # stupid_error
sudo apt autoremove -y
sudo shutdown -r +1 # reboot in 1 minute

# to uninstall
# sudo apt purge realtek-rtl88xxau-dkms -y
# sudo apt purge dkms -y
# sudo reboot