#!/bin/bash
echo -e "\n\n\nSTARTING TESSST\n\n\n"
disk=""
log="log.log"
echo > "$log" # initialize to empty

lsblk
read "Enter Disk Name (ex. sda, sdb no /dev or anything else) " disk_choice

disk="/dev/$disk_choice"

# echo "runnin inline xz"
# sudo dd if=$disk status=progress bs=1M | xz -c > throwaway_image_post0_inline_xz_14052026.img.xz

echo "runnan raw dd img"
sudo dd if=$disk of=throwaway_image_post0_raw_dd_img_14052026.img status=progress bs=1M | tee -a "$log"

echo "xz compressing raw dd img"
xz -v -k throwaway_image_post0_raw_dd_img_14052026.img | tee -a "$log" # yieldds throwaway_image_raw_dd_img_14052026.img.xz

echo "testing inline xz file"
xz -t -v throwaway_image_post0_inline_xz_14052026.img.xz | tee -a "$log"

echo "testing raw dd xz img.xz"
xz -t -v throwaway_image_post0_raw_dd_img_14052026.img.xz | tee -a "$log"

echo "generating sha256 checksums"
echo > checksums.sha256 # clear for initial
sha256sum *.img | tee -a checksums.sha256
sha256sum *.xz | tee -a checksums.sha256

echo -e "\n\n\nFUCKING FINAALLY ITS OVER\n\n\n"