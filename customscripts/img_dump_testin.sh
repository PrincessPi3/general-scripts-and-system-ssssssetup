#!/bin/bash
timestamp="$(date +%Y-%m-%d-%H%M-%Z)"
echo -e "\n\n\nSTARTING TESSST\n\n\n"
disk=""
log="${timestamp}_img_dump_testin.log"
echo > "$log" # initialize to empty
img_name="${timestamp}_Kali-Pi5-1TB-Working.img"

lsblk
read -p "Enter Disk Name (ex. sda, sdb no /dev or anything else) " disk_choice
disk="/dev/$disk_choice"

# echo "runnin inline xz"
# sudo dd if=$disk status=progress bs=1M | xz -c > throwaway_image_post0_inline_xz_14052026.img.xz

webhook "runnan raw dd img on $disk at 4M bs size (Script Has Run $SECONDS Seconds)"
sudo dd if="$disk" of="$img_name" status=progress bs=4M | tee -a "$log"

webhook "generating sha256 checksum of $img_name (Script Has Run $SECONDS Seconds)"
sha256sum "$img_name" | tee -a "$img_name.sha256"

webhook "xz compressing raw $img_name.xz (Script Has Run $SECONDS Seconds)"
xz -v "$img_name" | tee -a "$log" # yieldds throwaway_image_raw_dd_img_14052026.img.xz

webhook "testing raw dd xz $img_name.xz (Script Has Run $SECONDS Seconds)"
xz -t -v "$img_name.xz" | tee -a "$log"

webhook "Generating sha256 checksums of $img_name"
sha256sum "$img_name.xz" | tee -a "$img_name.xz.sha256"

webhook "\n\n\nFUCKING FINAALLY ITS OVER\n\n\n\t$SECONDS Seconds Elapsed\n\tDateTime Started: $timestamp DateTime Finished: $(date +%Y-%m-%d-%H%M-%Z)"