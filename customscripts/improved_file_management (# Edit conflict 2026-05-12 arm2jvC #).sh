#!/bin/bash

backup_dir="/mnt/c/Users/human/Downloads/tint"
cd "$backup_dir"

# sum text colorz
RED='\033[0;31m' # anmgry red
YELLOW='\033[0;33m' # BOLD yellow :"3
GREEN='\033[1;32m' # bold green :3
RESET='\033[0m' # reset color

verify_sha256_files() {
    local file
    local failed=0

    find "${1:-.}" -type f -name '*.sha256' -print0 |
    while IFS= read -r -d '' file; do
        echo "Checking: $file"

        if ! sha256sum -c "$file"; then
            echo "FAILED: $file" >&2
            failed=1
        fi
    done

    return "$failed"
}

generate_sha256_checksum_files () {
# make any new checksums
find . -type f -exec bash -c '
for file do
    if [[ "$file" =~ .sha256$ ]]; then
        echo "Skipping $file"
        continue
    else
        echo "making checksum of $file"
        sha256sum "$file" | tee "$file.sha256"
    fi
done
' bash {} +
}

if [ ! -d ".git" ]; then 
    echo -e "${GREEN}Not a Git Directory, initiating a git repo${RESET}"
    git init
    git add .
    git commit -m "First Autoinit at $(date)"
else
    echo -e "${GREEN}archiving everything to git${RESET}"
    git add .
    git commit -m "Autoarchive at $(date)"
fi