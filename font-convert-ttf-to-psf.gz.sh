#!/bin/bash
# todo:
## x green/red feedback from conditionals
### x system check etc
## x green title
## x debug
## x retcode snitch

# text formattan
RED='\033[0;31m' # error/faggin
GREEN='\033[0;32m' # A-OK
YELLOW='\033[1;33m' # bold yellow
RESET='\033[0m'

retcode_snitch() {
    ret=$1

    # check if retcode exits else red error return 1
    if [ -z "$ret" ]; then
        echo -e "\t${RED}ERROR: RETCODE EMPTY${RESET}"
        return 1 # lil error
    fi
    
    # if retcode be 0 den green ok
    if [ "$ret" -eq 0 ]; then
        echo -e "\t${GREEN}OK${RESET}"
    else # if not red error display retcode return 1
        echo -e "\t${RED}ERROR: $ret${RESET}"
        return 1 # lil erroz
    fi
}

# if arg3 is FAG den safe and gay mode enbled
if [[ $3 == "FAG" ]]; then
    echo -e "\n\n\n${RED}FAGGOT MODE SELECTED FAGGOT MODE RUNNING\n\tWARNING: YOU ARE A FAGGOT FOR BEING SAFE${RESET}\n\n\n"
    
    set -e # be a bitch and fail on error
    retcode_snitch $? # becuz im a bitch
fi

here="$(pwd)" # get da pwd fuuuck
pwdhere="$PWD" # difference?

# substr
## parse da shit
file_name="$1"
file_name_no_ext="${here}/${file_name:0:-4}"

# defien da fielz
file_path_ttf="${file_name_no_ext}.ttf"
file_path_bdf="${file_name_no_ext}.bdf"
file_path_psf="${file_name_no_ext}.psf"
file_path_psf_gz="${file_path_psf}.gz"

# check for debpoog
if [[ $2 == "DEBUG" ]]; then
    echo -e "\n${YELLOW}BEGIN DEBUG"
    echo -e "arg1 (ttf file): $1"
    echo -e "arg2 (debug): $2"
    echo -e "arg3 (safe mode aka ${RED}FAGGOT MODE${RESET}${YELLOW}): $3"
    echo -e "file_name: ${file_name}"
    echo -e "file_name_no_ext: ${file_name_no_ext}"
    echo -e "here: ${here}"
    echo -e "pwdhere: ${pwdhere}"
    echo -e "file_path_ttf: ${file_path_ttf}"
    echo -e "file_path_bdf: ${file_path_bdf}"
    echo -e "file_path_psf: ${file_path_psf}"
    echo -e "file_path_psf_gz: ${file_path_psf_gz}"
    echo -e "END DEBUG${RESET}\n"
fi

# check to see if da packages r installed
# if no, install dem
## bdf2psf
if [ -z $(which bdf2psf) ]; then
    echo -e "\n${YELLOW}bdf2psf not found, installing...${RESET}\n"
    
    # updoot
    sudo apt update
    retcode_snitch $?

    # install
    sudo apt install bdf2psf -y
    retcode_snitch $?
fi
## otf2bdf
if [ -z $(which otf2bdf) ]; then
    echo -e "\n${YELLOW}otf2bdf not found, installing...${RESET}\n"
    
    # updoot
    sudo apt update
    retcode_snitch $?

    # install
    sudo apt install otf2bdf -y
    retcode_snitch $?
fi
## gzip
if [ -z $(which gzip) ]; then
    echo -e "\n${YELLOW}gzip not found, installing...${RESET}\n"
    
    # updoot
    sudo apt update
    retcode_snitch $?

    # install
    sudo apt install gzip -y
    retcode_snitch $?    
fi
## maek sure file ends with ttf case insensisitive
shopt -s nocasematch # sum bullshit to maek da regex work
if [[ ! $file_name =~ ttf$ ]]; then # if does not end in ttf case insensitive
    echo -e "\n\n\n${RED}${file_name} is not ttf format! Exiting!${RESET}\n\n\n"
    exit 1
fi
## check da ttf exists and is a fiel
if [ ! -f "$file_path_ttf" ]; then # if fiel no exit
    echo -e "\n\n\n${RED}$file_path_ttf is not a valid file! Exiting!${RESET}\n\n\n"
    exit 1
fi

# convoot
## convert ttf to bdf
echo -e "\n${GREEN}Converting $file_path_ttf to $file_path_bdf${RESET}\n"
otf2bdf -p 16 -r 72 -o "$file_path_bdf" "$file_path_ttf"
retcode_snitch $?
## convert bdf to psf
echo -e "\n${GREEN}Converting $file_path_bdf to $file_path_psf${RESET}\n"
bdf2psf "${file_name_no_ext}.bdf" /usr/share/bdf2psf/standard.equivalents /usr/share/bdf2psf/fontsets/Uni1.512 512 "${file_name_no_ext}.psf"
retcode_snitch $?
## compress psf to psf.gz
echo -e "\n${GREEN}Compressing $file_path_psf to $file_path_psf_gz${RESET}\n"
gzip "$file_path_psf"
retcode_snitch $?