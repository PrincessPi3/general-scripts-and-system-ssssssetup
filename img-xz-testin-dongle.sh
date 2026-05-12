#!/bin/bash
# get da starting timestamp
start_date=$(date)
start_seconds=$(date +%s) # unix seconds

# RED colored text because sonic.exe
RED='\033[0;31m'
YELLOW='\033[0;33m' # BOLD yellow :"3
RESET='\033[0m'

# sum safety bs idk fam im not a europe
# run with FAG as first arg to be safe liek a bitch
if [[ "$1" == "FAG" ]]; then
    # warn user of faggotry
    echo -e "\n\n\n${RED}FAGGOT MODE ENABLED THIS MEANS YOU ARE A FAGGOT${RESET}\n\n\n"

    # make a safe space for the fag inclined
    set -euo pipefail # sum safrety shit idk
    shopt -s nullglob # safrety?
fi

# NO REASON **NOT** TO ANNOUNCE MY SHIT 4 FUN
echo -e "\n\n\n${RED}BEHOLD I AM RED AS FUUUUCK${RESET}\n${YELLOW}I AM NOW RUNNING AND YOU CAN NOT STOP ME FAGGOT${RESET}\n\n\n"

# silly trap runs on ANY exit huehuehue also always forces retcode 0 for extra conf
## silly trap to be tricky :3
trap 'sudo shutdown +5; exit 0' EXIT # shutdown da dinggus pls IN FIVE MINS on exxeic

# da sillyvars
here="/home/princesspi/Downloads/detritus"
LOG="$here/log_sha256_test_retcode_duhb.txt"
PRIV1="$here/PRIVATE_sda-2026-05-03_1.img"
PRIV2="$here/PRIVATE_sda-2026-05-03_2.img"
COPYPROTECT="$here/PRIVATE_sda_COPYPROTECT.img"

# lookit dis fancy ass process substitution PLUS output redirecting~ :fluttercum:
exec > >(tee -a "$LOG") 2>&1 # outdootz stdio and stderr both to terminal and to $LOG

# start notice
webhook "\n\n\nstart: $(date)\nLOG: $LOG\nPRIV1: $PRIV1\nPRIV2: $PRIV2\nCOPYPROTECT: $COPYPROTECT\n\n\n" true

# warn user of hell incoming
echo -e "\n\n\n${RED}DOIN DA BORING ASS SLOW SAFETY SHIT KILL ME NOW${RESET}\n\n\n\n"

# make backup of copy protect
start=$SECONDS
cp "$COPYPROTECT" "${COPYPROTECT}.bak"
cp_code=$? # sillywow
chmod 444 "$COPYPROTECT" "${COPYPROTECT}.bak"
chmod_code=$?
chown root:root "$COPYPROTECT" "${COPYPROTECT}.bak"
chown_code=$?
echo -e "\n\n\n${YELLOW}Copyprotect complete in $(($SECONDS-$start)) seconds ret: $cp_code chmod ret: $chmod_code chown ret: $chown_code${RESET}\n\n\n"
unset start

# generate dem sha256sums for safety
start=$SECONDS
sha256sum "$here"/*.img "$here"/*.bak "$here"/*.xz "$here"/*.sh "$here"/*.txt | tee -a "$LOG" # log dem checksumz to da logggy
sha256sum_code=$?
echo -e "\n\n\n${YELLOW}sha256sum generated of all files in $(($SECONDS-$start)) seconds and saved to $LOG ret: $sha256sum_code${RESET}\n\n\n"
unset start

# log both human readable and num of bytes filesizes
du -h "$here"/*.img "$here"/*.xz | tee -a "$LOG"
duh_code=$?
du -b "$here"/*.img "$here"/*.xz | tee -a "$LOG"
dub_code=$?
echo -e "\n\n\n${YELLOW}du -h ret: $duh_code du -b ret: $dub_code${RESET}\n\n\n" # ig give me dem retcodez or whatever 

# celebrate finish of prereqs
echo -e "\n\n\n${RED}FUCKING GOD DAMNED FINISHED ALL THE BORING SAFETY TUMORS AT $(date)${RESET}\n\n\n"

# test da xz raw compress
start=$SECONDS
xz -c "$PRIV2" > "${PRIV2}.xz" # dis maintainz da original too yay
xz_code=$? # ysusss gimme retint
echo -e "\n\n\n${YELLOW}xz raw compress complete in $(($SECONDS-$start)) seconds xz raw ret: $xz_code${RESET}\n\n\n"
unset start

# test da pishrink fancy+xz compress
start=$SECONDS
pishrink -v -r -Z -a "$PRIV1" "${PRIV1}.xz"
pishrink_code=$? # gimme dat return status pls
echo -e "\n\n\n${YELLOW}pishrink+xz complete in $(($SECONDS-$start)) seconds pishrink+xz ret: $pishrink_code${RESET}\n\n\n"
unset start

# xz (all) test+retcode and webhookie
start=$SECONDS
xz -t "$here"/*.xz | tee -a "$LOG"
xz_test_code=$? # mah retcode :3
echo -e "\n\n\n${YELLOW}xz test complete in $(($SECONDS-$start)) seconds xz test ret: $xz_test_code${RESET}\n\n\n"
unset start

# return da retcodez ig
webhook "\n\n\ncp code: $cp_code\nxz raw: $xz_code\nxz test: $xz_test_code\nsha256sum code: $sha256sum_code\npishrink code: $pishrink_code\n\n\n" true # log dat retcode to webhook

# notify of $LOG
webhook "\n\n\nLOGGIE :3\n$(cat \"$LOG\")\n\n\n" true

# notify of finish
webhook "\n\n\nfuckell it done fuuuck finished: $SECONDS elapsed at $(date)\nPOWERING OFF IN 5 MINUTES\n\n\n" true

# stop
echo -e "\n\n\n${RED}total $SECONDS seconds elapsed finished at $(date) started at ${start_date} finished in $((`date +%s`-$start_seconds)) seconds ${RESET}\n\n\n"

# manually shut tf off frong with conf exit :3
sudo shutdown +5 # delete to shutdown in 5 mins
exit 0 # never exit on bad code because conf :3