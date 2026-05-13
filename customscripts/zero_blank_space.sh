#!/bin/bash
zero_file_path="$PWD/0.0"

if [ -f "$zero_file_path" ]; then
    echo "Existing $zero_file_path, deleting it"
    sudo rm -f "$zero_file_path"
fi

echo -e "\n\nmakin a huge ass file filled wit nothing but zeros and when ya drive/partition runs out of room, it deletes da file. filane path: $zero_file_path\n\n"

# fill $PWD/zerofile.zero with nulls from /dev/zero
# when an error occurs (the script running out of space on the disk), it delivers all dat good stuff and clean up
sudo dd if=/dev/zero bs=1M status=progress >> "$zero_file_path" || echo -e "$zero_file_path file reached max size, deleting"; sudo rm -f "$zero_file_path"; echo -e "retcode: $?"

if [ -f "$zero_file_path" ]; then
    echo "Somehow $zero_file_path persists! nukin it~"
    sudo rm -f "$zero_file_path"
fi

echo -e "\n\nall dne :3 free space haz been zeroed nuaa~\n\n"

echo "shuttan down nowww to recoverrr"
sudo shutdown -r now