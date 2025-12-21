#!/bin/bash
# usage
#     # dry run is default without args
#     sync_dildo_repos.sh
#     # any arg in $1 place sends it
#     sync_dildo_repos.sh true

if [ -z "$1" ]; then
    dry_run=true
else
    dry_run=false
fi

# MY SILLYFILLY HAPPY REPONIES
master_repo="/mnt/c/Users/human/OneDrive/Documents/Git/Media-Viewer"
pi_repo="pi3:/var/www/html/Media-Viewer"
local_www_repo="/var/www/html/Media-Viewer"

echo -e "\nsyncing master repo to local www wsl repo\n"

if $dry_run; then # dry run mode
    echo -e "\nSELECTED MODE DRY RUN\n"

    # local www wsl
    echo -e "\nLOCAL WWWW WSL REPO (DRY RUN)\n\t$local_www_repo\n"
    rsync -avz --exclude='files/' --delete --dry-run "$master_repo" "$local_www_repo"
    echo -e "\nEND LOCAL WWW WSL REPO: $?\n"

    # remote pi3 repo
    echo -e "\nREMOTE PI3 REPO (DRY RUN)\n\t$pi_repo\n"
    rsync -avz --exclude='files/' --delete --dry-run "$master_repo" "$pi_repo"
    echo -e "\nEND PI5 REPO: $?\n"
else
    echo -e "\nSELECTED! LIVE! MODE!\n"

    # local www wsl
    echo -e "\nLOCAL WWWW WSL REPO (LIVE!)\n\t$local_www_repo\n"
    rsync -az --exclude='files/' --delete "$master_repo" "$local_www_repo"
    echo -e "\nLOCAL WWW WSL REPO DONE: $?\n"

    # remote pi3/pi5-usb-2
    echo -e "\nREMOTE PI5 REEPO (LIVE!)\n\t$pi_repo\n"
    rsync -az --exclude='files/' --delete "$master_repo" "$pi_repo"
    echo -e "\nPI5 REPO DONE: $?\n"
fi

echo -e "\ndone :pope:\n"
