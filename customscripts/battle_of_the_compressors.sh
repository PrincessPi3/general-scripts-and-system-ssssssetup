#!/bin/bash
# todo:
## seperate out values
### x compression ratios
### x avg cpu and memory load (free and uptime?)
### x time to complete
### parse apart before and after mem values and display deltas

log_file="$(date +"%Y-%m-%d-%H%M-%S")_compressor_battle.log" # file safe sortable timestamp
# exec 2> >(tee -a "$log_file" >&2) # output all errs to terminal and log file
echo > "$log_file" # clean and initialize log file

# SUM TEXT COLORS
RED='\e[31m'
GREEN='\e[1;32m'
RESET='\033[0m'

echo -e "\n${GREEN}Battle of the img compressions${RESET}\n"

# first, delete any outstanding logs or compressed files
if [[ "$2" =~ nuke ]]; then
    echo -e "${GREEN}Deleting old Files because NUKE was specified${RESET}"
    rm -f *.log *.zip *.xz *.tar *.gz *.7z
    echo -e "${GREEN}Done!${RESET}"
fi

if [ ! -f "$1" ]; then
    echo -e "\n\n\n${RED}No image File Specified, exiting${RESET}"
    exit 1
else
    echo -e "${GREEN}OK!${RESET} $1 is a file and it exists" 
    img_file="$1"
fi

# xz
echo -e "\n${GREEN}Starting test with xz${RESET}\n"
xz_start=$(date +%s)
xz -k -v "$img_file"
xz_end=$(date +%s)
xz_time=$(($xz_end - $xz_start))
xz_img_size=$(du --bytes "$img_file" | awk '{print $1}')
xz_compressed_size=$(du --bytes "$img_file.xz" | awk '{print $1}')
xz_compression_ratio=$(($xz_compressed_size / $xz_img_size))
echo -e "\n\nxz_img_size: $xz_img_size xz_compressed_size: $xz_compressed_size xz_compression_ratio: $xz_compression_ratio seconds: $xz_time start: $xz_start end: $xz_end\n\n"
# echo -e "Size of file $img_file is: $(du -h $img_file | awk '{print $1}') or $(du --bytes $img_file | awk '{print $1}') bytes taking $xz_time seconds to complete" | tee -a "$log_file"
# echo -e "Size of the compressed file is $(du -h $img_file.xz | awk '{print $1}') or $(du --bytes $img_file.xz | awk '{print $1}') bytes" | tee -a "$log_file"

# gzip
echo -e "\n${GREEN}Starting test with gzip${RESET}"
gz_start=$(date +%s)
gzip -k -v "$img_file"
gz_retcode=$?
gz_end=$(date +%s)
gz_time=$(($gz_end - $gz_start))
gz_img_size=$(du --bytes "$img_file" | awk '{print $1}')
gz_compressed_size=$(du --bytes "$img_file.gz" | awk '{print $1}')
gz_compression_ratio=$(($gz_img_size / $gz_compressed_size))
echo -e "\n\n${GREEN}GZ Finished!\n\tgz_img_size: $gz_img_size\n\tgz_compressed_size: $gz_compressed_size\n\tgz_compression_ratio: $gz_compression_ratio\n\tseconds: $gz_time\n\tstart: $gz_start\n\tend: $gz_end \n\tretcode: $gz_retcode${RESET}\n\n"
# echo -e "Size of file $img_file is: $(du -h $img_file | awk '{print $1}') bytes taking $gz_time seconds to complete" | tee -a "$log_file"
# echo -e "Size of the compressed file is $(du -h $img_file.gz | awk '{print $1}') or $(du --bytes $img_file.xz | awk '{print $1}') bytes" | tee -a "$log_file"

# tar
echo -e "\n${GREEN}Starting test with tar${RESET}\n"
tar_start=$(date +%s)
tar -cvf "$img_file.tar" "$img_file"
tar_retcode=$?
tar_end=$(date +%s)
tar_time=$(($tar_end - $tar_start))
tar_img_size=$(du --bytes "$img_file" | awk '{print $1}')
tar_compressed_size=$(du --bytes "$img_file.tar" | awk '{print $1}')
tar_compression_ratio=$(($tar_img_size / $tar_compressed_size))
echo -e "\n\n${GREEN}TAR Finished!\n\ttar_img_size: $tar_img_size\n\ttar_compressed_size: $tar_compressed_size\n\ttar_compression_ratio: $tar_compression_ratio\n\tseconds: $tar_time\n\tstart: $tar_start\n\tend: $tar_end \n\tretcode: $tar_retcode${RESET}\n\n"
# echo -e "Size of file $img_file is: $(du -h $img_file | awk '{print $1}') or $(du --bytes $img_file | awk '{print $1}') bytes taking $tar_time seconds to complete" | tee -a "$log_file" 
# echo -e "Size of the compressed file is $(du -h $img_file.tar | awk '{print $1}') or $(du --bytes $img_file.tar | awk '{print $1}') bytes" | tee -a "$log_file"

# 7z
echo -e "\n${GREEN}Starting test with 7z${RESET}"
sevenz_start="$(date +%s)"
7z a "$img_file.7z" "$img_file"
sevenz_end=$(date +%s)
sevevnz_time=$(($sevenz_end - $sevenz_start))
seven_img_size=$(du --bytes "$img_file" | awk '{print $1}')
seven_compressed_size=$(du --bytes "$img_file.7z" | awk '{print $1}')
seven_compression_ratio=$(($sevem_img_size / $seven_compressed_size))
echo -e "\n\n${GREEN}7ZIP Finished!\n\tseven_img_size: $sevem_img_size\n\tseven_compressed_size: $seven_compressed_size\n\tseven_compression_ratio: $seven_compression_ratio\n\tseconds: $tar_time\n\tstart: $tar_start\n\tend: $tar_end \n\tretcode: $tar_retcode${RESET}\n\n"
# echo -e "Size of file $img_file is: $(du -h "$img_file" | awk '{print $1}') or $(du --bytes "$img_file" | awk '{print $1}') bytes taking "$sevenz_time" seconds to complete" | tee -a "$log_file"
# echo -e "Size of the compressed file is $(du -h "$img_file.7z" | awk '{print $1}') or $(du --bytes "$img_file.7z" | awk '{print $1}') bytes" | tee -a "$log_file"

# zip
echo -e "\n${GREEN}Starting test with zip${RESET}\n"
zip_start=$(date +%s)
zip -v "$img_file.zip" "$img_file"
zip_retcode=$?
zip_end=$(date +%s)
zip_time=$(($zip_end - $zip_start))
zip_img_size=$(du --bytes "$img_file" | awk '{print $1}')
zip_compressed_size=$(du --bytes "$img_file.zip" | awk '{print $1}')
zip_compression_ratio=$(($zip_compressed_size / $zip_img_size))
echo -e "\n\n${GREEN}ZIP Finished!\n\tzip_img_size: $zip_img_size\n\tzip_compressed_size: $zip_compressed_size\n\tzip_compression_ratio: $zip_compression_ratio\n\tseconds elapssed: $zip_time\n\tstart: $zip_start\n\tend: $zip_end \n\tretcode: $zip_retcode${RESET}\n\n"
# echo -e "Size of file $img_file is: $(du -h $img_file | awk '{print $1}') or $(du --bytes $img_file | awk '{print $1}') bytes taking $zip_time seconds to complete" | tee -a "$log_file"
# echo -e "Size of the compressed file is $(du -h $img_file.zip | awk '{print $1}') or $(du --bytes $img_file.zip | awk '{print $1}') bytes" | tee -a "$log_file"

echo -e "\n\n\n${GREEN}DONE :3 nyaa~${RESET}\n\n"