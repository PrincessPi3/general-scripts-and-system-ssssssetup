#!/bin/bash
# todo:
## x environment checks for webhook, xz-tools, and pishrink
### install if not found
## sanity checks in cleanup error trap to make sure nothing is wrongly deleted
## x ERR/TERMINATE traps
### x NO cleanup trap on EXIT
## x finish the pi query
## add filename query

set -euo pipefail # fail on fuckups to iterate fasterrr :pope: strict fuk u mode :3

timestamp="$(date +%Y-%m-%d-%H%M-%Z)"
disk=""
log="${timestamp}_img_dump_testin.log"
echo > "$log" # initialize to empty
img_name="${timestamp}_Kali-Pi5-1TB-Working.img"

check_command() {
    command -v "$1" >/dev/null 2>&1 || {
        # outputz it as errror
        echo >&2 "Required command '$1' not found. Install it and retry." | tee -a "$log"
        exit 1
    }
}

# check da needed cmds~
for cmd in webhook xz pishrink sha256 sudo lsblk dd; do
    check_command "$cmd"
done

# trap function cleanup
cleanup () {
    webhook "$0 errored! Cleaning up! seconds: $SECONDS line: $LINENO command: $BASHCOMMAND" true
    # supress errors if they not there
    # to save me from testing each one or writing a fun :poe:
    for file in "$img_name" "$img_name.sha256" "$img_name.xz" "$img_name.xz.sha256" "$log"; do
        if [ -f "$file" ]; then 
            echo "Deleting $file"
            sudo rm -f "$file" 2>/dev/null
        fi
    done
}

# cleanup any errant files on error/termination
trap cleanup ERR
trap cleanup SIGINT
trap cleanup SIGTERM

echo -e "\n\n\nSTARTING DUMP OPS\n\n\n"

lsblk
read -p "Enter Disk Name (ex. sda, sdb no /dev or anything else) " disk_choice
disk="/dev/$disk_choice"

read -p "For Raspberry Pi? y\n default y" picheck

# for when ask for tag
# read -p "Input File Tag" filetag
clear

webhook "runnan raw dd img on $disk at to $img_name using 4M bs size (Script Has Run $SECONDS Seconds)"
sudo dd if="$disk" of="$img_name" status=progress bs=4M | tee -a "$log"

webhook "Changing perms abd ownership on $img_name"
sudo chown princesspi:princesspi "$img_name"
sudo chmod 660 "$img_name"

webhook "generating sha256 checksum of $img_name (from $disk) to $img_name.sha256 (Script Has Run $SECONDS Seconds)"
sha256sum "$img_name" | tee -a "$img_name.sha256"

if [[ "$picheck" =~ [nN] ]]; then
    webhook "Doing non-pi xz compression on $img_name into $img_name.xz"
    xz -v "$img_name" | tee -a "$log"
else
    # pishrink
    ## -v verbose
    ## -r use advanced filesystem repair option if the normal one fails
    ## -Z xz compression
    ## -a compress using multiple cores
    webhook "Doing pi compress using pishrink from $img_name ($disk) to $img_name.xz (Script Has Run $SECONDS Seconds)"
    pishrink -v -r -Z -a "$img_name" | tee -a "$log"
fi

# pishrink
## -v verbose
## -r use advanced filesystem repair option if the normal one fails
## -Z xz compression
## -a compress using multiple cores
webhook "doing pishrink from $img_name ($disk) to $img_name.xz (Script Has Run $SECONDS Seconds)"
pishrink -v -r -Z -a "$img_name" | tee -a "$log"

webhook "testing xz integrity: $img_name.xz (Script Has Run $SECONDS Seconds)"
xz -t -v "$img_name.xz" | tee -a "$log"
webhook "xz integrity response code: $?"

webhook "Generating sha256 checksums of $img_name.xz to $img_name.xz.sha256 (Script Has Run $SECONDS Seconds)"
sha256sum "$img_name.xz" | tee -a "$img_name.xz.sha256"

if [ -f "$img_name" ]; then
    webhook "$img_name still there! Deleting by force!"
    sudo rm -f "$img_name"
fi

webhook "\n\n\nFUCKING FINAALLY ITS OVER\n\n\n\t$SECONDS Seconds Elapsed\n\tDateTime Started: $timestamp DateTime Finished: $(date +%Y-%m-%d-%H%M-%Z)"