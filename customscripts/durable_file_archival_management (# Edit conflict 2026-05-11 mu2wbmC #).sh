#!/bin/bash
# todo
## x make safe and gay mode optional
## dont re-fuck existing sha256 files ig
##     or ig test and leave as is or append new val and date
## x joplin export as pdf
## x git (?)
## x args normalization
# x if args contain FAG (case insensitive) den gay and safe mode enabled
# x if args contain NUKE (case insensitive) den nuke all dem sha256 files
# x if args contain GIT (case insensitive) den ig do da fuckin asshole git b
# x if args contain VALIDATE (case insensitive) then verify sha256 cheksums from pre-calculated files
## nosleep start and stop
## x clean up/create error.log
## test for files missing paired sha256 files, log to error.log
## test for mismatches to sha256 files log to error.log
## x set error trap to ensure all stderr is tee -a'd to terminal and error.log
## fast scan for attributes vs slow scan with sha256
## both scans always running, alongside looping restic backups
## solve any race conditinos
## environment check
## sanity checks
## duplicate/conflict behavior

# date shit
start_date="$(date)" # date ig

# sum text colorz
RED='\033[0;31m' # anmgry red
YELLOW='\033[0;33m' # BOLD yellow :"3
GREEN='\033[1;32m' # bold green :3
RESET='\033[0m' # reset color

echo -e "${GREEN}Script Started at $start_date With $SECONDS Seconds Elapsed on Line number: $LINENO${RESET}"

# get all dem args into one single fuck (space seperated)
argz="$@"

# do you wanna be a safetyfag or be based?
shopt -s nocasematch # magic no case match bs
set -Eeuo pipefail # fail on any error including pipe fail and use error trap
# backup_dir="/mnt/d/Anbernic_Research_Tinkering_Save" # dir to protect
backup_dir="/mnt/c/Users/human/Downloads/tint"
error_log="${backup_dir}/error.log" # errror log path
path_error_log="$error_log" # duplicated cus lazy
exec 2> >(tee -a "$path_error_log" >&2) # output any stderror to both screen and error log
cd "$backup_dir" # enter dir to work in

if [ -f $path_error_log ]; then
    echo -e "${GREEN}Found $path_error_log clearing at $(date) With $SECONDS Elapsed At Line Number $LINENO${RESET}"
    echo > "$path_error_log" # initialize as empty
else
    echo -e "${GREEN}No $path_error_log fiound, creating at $(date) With $SECONDS Elapsed At Line Number $LINENO${RESET}"
    touch "$path_error_log" # create and initialize
fi

# on error, fail and dump as much information as possible to terminal, webhook, and error log
# trap error_handler ERR
error_handler () { 
    infostring="${RED}\n\n\nERROR IN SCRIPT:\n\n\t$SECONDS Seconds Elapsed\n\tDate $(date)\n\tOn Line: $LINENO\n\tUsing command $BASH_COMMAND\n\tReturn Code: $?\n\tError log: $path_error_log\n\tRecorded Args: ${@}${RESET}\n\n"
    webhook "$infostring" true # dump data to terminal and webhook
    echo -e >> "$path_error_log" # dump data to error log
}

echo -e "${GREEN}Made it past varr declaratgions and such at $(date) With $SECONDS Elapsed At Line Number $LINENO${RESET}"

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

    # test for error log
    if [ ! -f "$path_error_log" ]; then
        echo -e "\n\n\n${RED}error log at path: $path_error_log not present, not available, out of permissions, or is not a directory${RESET}\n\n\n" # notify

        exit 1
    else
        echo -e "${GREEN}OK! Error Log GOOD${RESET}"
    fi

    echo -e "${GREEN}Environment Checks GOOD!${RESET}"
}

# if [[ "$argz" =~ "FAG" ]]; then
#     echo -e "\n\n\n${RED}OK FAGGOT YOU RAN ARG1 WITH FAG SO NOW YOU GET FUCKFAG SAFE MNODE LIKE THE QUEER U R${RESET}\nOH YE ALL YA GAY LIL ERRORS NOW LOGGIN TO $path_error_log\n\n\n"
#     # make da error log for further humiliation\
#     # if error log present, delete it and replace with blank file
#     if [ -f "$path_error_log" ]; then
#         rm -f "$path_error_log" # delete
#         touch "$path_error_log" # make empty file
#     fi
#     # notify the user of what a genuine bitch they are
# fi

# makin a trappy to make sure as fuuuck dat no fucky wucky gets dafuq by meeee
# trap '\033[0;31m webhook "SHIT SHIT SHIT SHIT DA EXIT TRAP FUCKIN SPRUNG FFUUUCK\n\tLine number: $LINENO\n\tFailing on command $BASH_COMMAND\y\tResponse code: $?\n\tStderr shown on screen and logged to $path_error_log ${RESET}\nArgs returned: $@\n\t\n\n\033[0m' EXIT 

function generate_sha256_checksums () {
    webhook "${GREEN}startin calculatin all dem gay af sha256 files\n\t$SECONDS seconds elapsed\n\tDate: $(date)${RESET}"

    # use black magic to generatre da sha256 files
    find "$backup_dir" -prune -o -name ".git" -type f -name "*.sha256" -exec bash -c "sha256sum {} | tee -a {}.sha256" \; # bash -c "for f in \"\$@\"; do if [ -f \"\${f}.sha256\" ]; then continue; fi; sha256sum -c \"\${f}.sha256\" | tee -a \"${path_error_log}\"; done" _ {} + # sum horrifying shitfuck idk

    webhook "${GREEN}finished calculatin all dem gay af sha256 files\n\t$SECONDS seconds elapsed${RESET}"
}

# ig git is unsuited for version controllin fuckhuge fiels ig
## so ig i comment it out
## sum git shit to maintain archive or sum shit
## if arg1 containz GIT then do da gitshit
do_git () {
    # notify the user of this bullshit
    echo -e "${GREEN}FAggot im doin da fuckin git bullshit even tho is fuckslow${RESET}"
    webhook "doin sum git"
    # do da git conditionally if need be init
    if [ ! -d "${backup_dir}/.git" ]; then # if .git dir not be there, initialize it fag
        git -C "$backup_dir" init 2>/dev/null  # init git if da shit aint there
        # git -C "$backup_dir" branch -m master # set branch to main (?)
        git -C "$backup_dir" add "$backup_dir"
        git -C "$backup_dir" commit -m "initial auto archive date: $(date +%s)"
    else
        git -C "$backup_dir" add "$backup_dir" # add
        git -C "$backup_dir" commit -m "auto archive $(date +%s)" # commit wit date
        # notify finished with fuckgit
    fi

    webhook "done doin sum git"

}

# do da fookin sha256sums first ig
# # if arg1 contains NUKE (case insensititve den nuke dem fuckin sha256 fiels)
# if [[ "$argz" =~ "NUKE" ]]; then
#     webhook "startin sha256 clearin\n\t$SECONDS seconds elapsed"
#     # notify user that they are a fag
#     echo -e "${RED}FAGGOT MODE ENABLED SO IM NUKIN ALL DEM SHA256 FIELS FUCK U${RESET}"
#     # nuke da sha256 files finafuckingky
#     find "$backup_dir" -prune -o -name ".git" -type f -name "*.sha256" -delete # nuke dem fookan fuckfiels
#     # finished nukan math
#     webhook "${GREEN}finished clearin sha256 fiels\n\t$SECONDS seconds elapsed${RESET}"
# 
#     webhook "Now creating new sha256 sums files"
#     generate_sha256_checksums
# fi

# check already generated sha256 checksums
# if [[ "$argz" =~ "VALIDATE" ]]; then
check_generate_checksums () {
    webhook "Generating new sha256sums files for those that lack one"
    generate_sha256_checksums

    webhook "\n\nchecking pre-calculated sha256 sums"
    # find every sha256 file do the checksum
        find "$backup_dir" -prune -o -name ".git" -type f -iname "*.sha256" -exec bash -c "echo -e \"${GREEN}\nstarting check sha256sums of files\n\tcurrent file: {}\n\t total elpapsed: $SECONDS seconds\n\"; sha256sum -c {} | tee -a \"${path_error_log}\"; echo -e \"ARGS: $@\n\n${RESET}\"" \; 
}

restic_backups () {
    webhook "runnin Anbernic backup restic powershell\n\t$SECONDS seconds elapsed"
    # may god have mercy on my soul for mixing powershell and bash
    pwsh.exe -File "D:\Anbernic-Hackin-Archive_restic_backup.ps1" # do da restic backup ps1
    # finished restic backloops
    webhook "finished runnin restic Anbernic shit\n\t$SECONDS seconds elapsed"
}

box_force_shutdown () {
    # shutdown by force of powershell huehhuehue
    webhook "TIME TO SHUT THE FUCK DOWN WOOOO\n\t$SECONDS Seconds Elapsed\n\tStart Date: $start_date\n\tEnd Date: $(date)" true # true so it pingas mneeee

    # hateful cursed powershell call to shut off box ffs
    # pwsh.exe -C "Stop-Computer -Force" # i reeally dgaf this is so terribly fuckin cursed    
}

environment_checks
do_git
check_generate_checksums
restic_backups
# box_force_shutdown