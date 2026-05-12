#!/bin/bash
set -e # bitchass cant be trusted without handholding
exec 2>/dev/null # fookin thing gonna be error city bec i cbf so null dem

echo "Fixan ya fuckin .ssh perms you useless fagat"

# if ~/.ssh dont exist, maek it
if [ ! -d ~/.ssh ]; then
    echo "bitch u dont even have a fuckin ~/.ssh lemme make dat for you fraggot"
    mkdir -p ~/.ssh # -p for error control/happydoll
fi

# ~/.ssh dir perms
echo "fixin perms on ~/.ssh because you're too dipshitted to do it yourself"
chmod 700 ~/.ssh

# privkey perms
echo "now im fixin perms on ya asshole private keys you are an embarassmebt to security"
chmod 600 ~/.ssh/id_rsa ~/.ssh/id_ed25519 ~/.ssh/config ~/.ssh/id_edchdsa

# public and less sensititve fiels perms
echo "now im fixin da perms on less sensitive files ig FUCK YOU"
chmod 644 ~/.ssh/authorized_keys ~/.ssh/known_hosts ~/.ssh/*.pub

echo "OK FAGGOT IM FINISHED"
echo "NEVER SPEAK OF THIS SHAME, FAGGOT"

exit 0 # always a friendly exit