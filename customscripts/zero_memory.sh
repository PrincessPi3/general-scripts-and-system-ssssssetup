#!/bash
# drop to skeleton mode
## unset everything possible
## kill as many processes as possible
# get list of all vars
## fill them to a comical length with /dev/zero
## then unset them
# figure out a more robust method

## otherwise jus drop a zerofile.zero into /tmp :vv:
## just fuckin
# will this crash shit?
temp_file="$(mktemp)"
sudo if=/dev/zero bs=4M status=progress > "$temp_file" || sudo rm -f "$temp_file"