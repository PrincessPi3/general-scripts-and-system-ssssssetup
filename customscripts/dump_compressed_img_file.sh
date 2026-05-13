#!/bin/bash
# todo:
# offline option
## dd raw .img
## enum partitions
### file zero fill empty space of good partitions
### dd zero fill unformatted space and such
### xz compress
# online option
## enum partitions
## attempt to mount all possible
## file zero fill them
## dd zero fill unformatted space
## take offline for xz inline rip

set -e # fail explicitly on any error

# todo: interactive, cli options
disk=/dev/sda
outname="test_disk_image_post0_$(date +%Y-%m-%d-%H%M-%Z)"
outname="$outname.img.xz"

# do the disk image dump using inline xz
echo "runnin inline xz on $disk to file $outname"
sudo dd if=$disk status=progress bs=1M | xz -c > "$outname"

# test xz integrity
echo "testing disk image integrity"
xz -t -v "$outname"

# make the sha256 file
echo "generating sha256 checksum file"
sha256sum "$outname" | tee "$outname.sha256"

echo "all donesies :3"
