#!/bin/bash

echo -e "\n\nmakin a huge ass file filled wit nothing but zeros and when ya drive/partition runs out of room, it deletes da file. filaneme: $PWD/zerofile.zero\n\n"

sudo dd if=/dev/zero bs=4M status=progress > "$PWD/zerofile.zero" || echo -e "zero file reached max size, deleting"; sudo rm -f "$PWD/zerofile.zero"; echo -e "retcode: $?"

echo -e "\n\nall dne :3 free space haz been zeroed nuaa~\n\n"