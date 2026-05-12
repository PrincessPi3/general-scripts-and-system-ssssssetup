#!/bin/bash
# usage: by its self or with nuke
# bash improved_file_management.sh
# bash improved_file_management.sh nuke
## "nuke" is not case sensitive
start_date="$(date)"
args="$@"

# backup_dir="/mnt/c/Users/human/Downloads/tint"
backup_dir="/mnt/c/Users/human/Downloads/tint"
error_log="${backup_dir}/error.log" # errror log path
cd "$backup_dir" # slide on in

# make errros get logged and also displayed to the terminal
exec 2> >(tee -a "$error_log" >&2)

# sum text colorz
RED='\033[0;31m' # anmgry red
YELLOW='\033[0;33m' # BOLD yellow :"3
GREEN='\033[1;32m' # bold green :3
RESET='\033[0m' # reset color

check_error_log () {
    if [ -f "$error_log" ]; then
        echo -e "${GREEN}Found $error_log clearing at $(date) With $SECONDS Elapsed At Line Number $LINENO${RESET}"
        echo > "$error_log" # initialize as empty
    else
        echo -e "${GREEN}No $error_log fiound, creating at $(date) With $SECONDS Elapsed At Line Number $LINENO${RESET}"
        touch "$error_log" # create and initialize
    fi
}

environment_checks () {
    # tests if backup dir is a directory and available
    if [ ! -d "$backup_dir" ]; then
        echo -e "\n\n\n${RED}Supplied backup dir: $backup_dir not present, not available, out of permissions, or is not a directory"

        exit 1
    else
        echo -e "${GREEN}OK! Backup Dir GOOD${RESET}"
    fi

    # tests current location
    if [[ "$PWD" != "$backup_dir" ]]; then
        echo -e "\n\n\n${RED}pwd: $PWD does not match specified dir: $backup Dir, FAIL. Exiting.${RESET}\n\n\n" # notify
        
        exit 1 # exit with error
    else
        echo -e "${GREEN}OK! Backup Dir IS Current Location!${RESET}"
    fi

    echo -e "\n${GREEN}Environment Checks GOOD!${RESET}\n"
}

greet () {
    echo -e "\n\n\n${GREEN}WELCOME TO DURABLE, PROVABLE FILE HANDLING${RESET}\n\n\n"
}

when_done () {
    echo -e "\n\n\n${GREEN}DONE :3 nyaa~!${RESET}\n\n\n"
}

delete_sha256_files () {
    echo -e "${GREEN}Nuking all .sha256 files in $backup_dir${RESET}\n"
    find . -type f -name "*.sha256" -not -path "*.git*" -delete
}

verify_sha256_files() {
    echo -e "${GREEN}verifying file's checksums${RESET}"
    local file
    local failed=0

    find "${1:-.}" -type f -name '*.sha256' -not -path "*.git*" -print0 |
    while IFS= read -r -d '' file; do
        echo "Checking: $file"

        if ! sha256sum -c "$file"; then
            # here is where i can handle bad checksums
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
    ' bash {} + # idk what this hippie bullshit voodoo witchcraft this syntax is, kill nme now
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

# shutdown by force of powershell huehhuehue
box_force_shutdown () {
    webhook "TIME TO SHUT THE FUCK DOWN WOOOO\n\t$SECONDS Seconds Elapsed\n\tStart Date: $start_date\n\tEnd Date: $(date)" true # true so it pingas mneeee

    # hateful cursed powershell call to shut off box ffs
    pwsh.exe -C "Stop-Computer -Force" # i reeally dgaf this is so terribly fuckin cursed    
}

greet # welcome msg
environment_checks # test environment for working
if [[ "$args" =~ nuke ]]; then
    delete_sha256_files # delete all *.sha256 files
fi
check_error_log # verify error log faggot

while $true; do # do an infinite loop to keep em all running and operating at all times :3
    verify_sha256_files # check files against their sha256 checksum
    generate_sha256_checksums # create the checksums from the files to generate each file its own *.sha256 buddy \o/
    do_git # archive for version controll
    run_backup # do multiple redndant backups using restic
done
when_done # goodbye msg
