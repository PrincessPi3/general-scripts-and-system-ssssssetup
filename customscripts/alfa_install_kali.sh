#!/bin/bash
# installs the Alpha AWUS036ACH on kali linux
# has some slowdowns and pauses to work around a stupid issuie i have

# make sure environment is up to date
sudo apt update
# sudo apt upgrade -y
# sudo apt dist-upgrade -y

# install dkms and rtl dkms
sudo apt-get install dkms -y
sudo apt-get install realtek-rtl88xxau-dkms -y

# download the code
# catch any submodules, only clone one branch, only download with two jobs to save stress # stupid_error
git clone --recursive --single-branch -jobs 2 https://github.com/aircrack-ng/rtl8812au.git /tmp/rtl8812au
sleep 10 # stupid_error

# build it
cd /tmp/rtl8812au # enter the dir
make -j 2 # use less juice to compile to save stress # stupid_error
sleep 10 # stupid_error

# install the module
sudo make install
sleep 10 # stupid_error

# cleanup
cd ~
rm -rf /tmp/rtl8812au
sleep 10 # stupid_error
sudo apt autoremove -y
sudo shutdown -r +1 # reboot in 1 minute