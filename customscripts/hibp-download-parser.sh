#!/bin/bash
max=65535 # FFFF
txtfile="/mnt/e/2025-12-17_hibp_sha1.txt"
outdir="/mnt/e/hibp_parsed"

if [ ! -d "$outdir" ]; then
    echo "creating $outdir"
    mkdir "$outdir"
else
    echo "clearing $outdir"
    rm -f "$outdir/*"
fi

# remove the carriage returns from file
# sed -i "s/\x0d//g" "$txtfile"

for ((i = 0; i <= $max; i++)); do
    HEX_VAL=$(printf "%04X" $i) # %04X to give padding 0s up to four
    echo "$HEX_VAL"
    rg -N "^$HEX_VAL" "$txtfile" >> "$outdir/$HEX_VAL.txt"
    echo $?
done