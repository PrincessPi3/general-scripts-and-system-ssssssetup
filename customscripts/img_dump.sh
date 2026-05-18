#!/bin/bash
set -e # fail on fuckups to iterate fasterrr

timestamp="$(date +%Y-%m-%d-%H%M-%Z)"
disk=""
log="${timestamp}_img_dump_testin.log"
echo > "$log" # initialize to empty
img_name="${timestamp}_Kali-Pi5-1TB-Working.img"

echo -e "\n\n\nSTARTING DUMP OPS\n\n\n"

lsblk
read -p "Enter Disk Name (ex. sda, sdb no /dev or anything else) " disk_choice
disk="/dev/$disk_choice"
clear

# echo "runnin inline xz"
# sudo dd if=$disk status=progress bs=1M | xz -c > throwaway_image_post0_inline_xz_14052026.img.xz

webhook "runnan raw dd img on $disk at to $img_name using 4M bs size (Script Has Run $SECONDS Seconds)"
sudo dd if="$disk" of="$img_name" status=progress bs=4M | tee -a "$log"

webhook "Changing perms abd ownership on $img_name"
sudo chown princesspi:princesspi "$img_name"
sudo chmod 660 "$img_name"

webhook "generating sha256 checksum of $img_name (from $disk) to $img_name.sha256 (Script Has Run $SECONDS Seconds)"
sha256sum "$img_name" | tee -a "$img_name.sha256"

### commented out in favor of pishrink
# webhook "xz compressing raw $img_name.xz (Script Has Run $SECONDS Seconds)"
# xz -v "$img_name" | tee -a "$log" # yieldds throwaway_image_raw_dd_img_14052026.img.xz

# if [ -f "$img_name" ]; then
#     webhook "$image_name still there! Deleting by force!"
#     sudo rm -f "$img_name"
# fi

# -v verbose
# -r use advanced filesystem repair option if the normal one fails
# -Z xz compression
# -a compress using multiple cores
webhook "doing pishrink from $img_name ($disk) to $img_name.xz (Script Has Run $SECONDS Seconds)"
pishrink -v -r -Z -a "$img_name"

webhook "testing xz integrity: $img_name.xz (Script Has Run $SECONDS Seconds)"
xz -t -v "$img_name.xz" | tee -a "$log"

webhook "Generating sha256 checksums of $img_name.xz to $img_name.xz.sha256 (Script Has Run $SECONDS Seconds)"
sha256sum "$img_name.xz" | tee -a "$img_name.xz.sha256"

webhook "\n\n\nFUCKING FINAALLY ITS OVER\n\n\n\t$SECONDS Seconds Elapsed\n\tDateTime Started: $timestamp DateTime Finished: $(date +%Y-%m-%d-%H%M-%Z)"