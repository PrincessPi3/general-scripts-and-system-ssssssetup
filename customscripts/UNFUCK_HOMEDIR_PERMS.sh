#!/bin/bash
username=princesspi
echo "UNFUCK HOMEDIR PERMS"
sudo chown -R $username:$username /home/$username 2>/dev/null
sudo chmod 755 /home/$username 2>/dev/null
sudo chmod 700 /home/$username/.ssh 2>/dev/null
sudo chmod 600 /home/$username/.ssh/id_rsa 2>/dev/null
sudo chmod 644 /home/$username/.ssh/id_rsa.pub 2>/dev/null
sudo chmod 600 /home/$username/.ssh/authorized_keys 2>/dev/null
sudo chmod 600 /home/$username/.ssh/config 2>/dev/null
sudo chmod 644 /home/$username/.ssh/known_hosts 2>/dev/null
sudo chmod 644 /home/$username/.ssh/id_ed25519.pub 2>/dev/null
sudo chmod 600 /home/$username/.ssh/id_ed25519 2>/dev/null