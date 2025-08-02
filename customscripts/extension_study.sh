#!/bin/bash
tmp_file="./exts.tmp"
exts_study_file="./extension_study.txt"

echo "" > "$tmp_file"
find files -type f -exec bash -c "echo \"{}\" | awk -F. '{print \$NF}' | tee -a \"$tmp_file\"" \;
cat "$tmp_file" | sort | uniq > "$exts_study_file"
rm -f "$tmp_file"

echo "DONE! Saved to $exts_study_file"