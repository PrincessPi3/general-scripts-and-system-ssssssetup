#!/bin/bash
# usage:
##   curl -sSL https://tinyurl.com/4meps4as | "$SHELL"
set -e # we do not fail here :chameleon:
echo -e "\nchanging/setting user password\n"
passwd
echo -e "\nsetting os to be writable\n"
sudo steamos-readonly disable
echo -e "\ninitalizing keys\n"
sudo pacman-key --init
echo -e "\npopulatiing keys\n"
sudo pacman-key --populate archlinux holo
echo -e "\nupdatikng repos\n"
sudo pacman -Syu
echo -e "\nall done!~ :3 install shit wikth pacman -S <package name>\n"