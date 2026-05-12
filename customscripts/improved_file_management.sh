#!/bin/bash

# backup_dir="/mnt/c/Users/human/Downloads/tint"
backup_dir="/mnt/d/Anbernic_Research_Tinkering_Save"
cd "$backup_dir"

# sum text colorz
RED='\033[0;31m' # anmgry red
YELLOW='\033[0;33m' # BOLD yellow :"3
GREEN='\033[1;32m' # bold green :3
RESET='\033[0m' # reset color

greet () {
    echo -e "\n\n\n${GREEN}WELCOME TO DURABLE, PROVABLE FILE HANDLING${RESET}\n\n\n"
}

when_done () {
    echo -e "\n\n\n${GREEN}DONE :3 nyaa~!${RESET}\n\n\n"
}

delete_sha256_files () {
    echo -e "${GREEN}Nuking all .sha256 files in $backup_dir${RESET}"
    find "$backup_dir" -not -path "*.git*" -type f -name "*.sha256" -delete
}

verify_sha256_files() {
    echo -e "${GREEN}verifying file's checksums${RESET}"
    local file
    local failed=0

    find "${1:-.}" -type f -name '*.sha256' -print0 |
    while IFS= read -r -d '' file; do
        echo "Checking: $file"

        if ! sha256sum -c "$file"; then
            echo -e "${RED}FAILED: $file${RESET}" >&2
            failed=1
        fi
    done

    return "$failed"
}

generate_sha256_checksums () {
# make any new checksums
    find . -type f -not -path "*.git*" -exec bash -c '
    for file do
        if [[ "$file" =~ .sha256$ ]]; then
            echo "Skipping $file"
            continue
        else
            echo -e "${GREEN}making checksum of $file${RESET}"
            sha256sum "$file" | tee "$file.sha256"
        fi
    done
    ' bash {} +
}

do_git () {
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
}

# to trigger an archival via restic
run_backup () {
    echo -e "\n\n${GREEN}Starting Restic Backup${RESET}\n\n"
    # unholy call restic script from powershell
    pwsh.exe -File "D:\Anbernic-Hackin-Archive_restic_backup.ps1" # do da restic backup ps1
}

greet
delete_sha256_files
generate_sha256_checksums
verify_sha256_files
do_git
run_backup
when_done