#!/bin/bash
# todo
## pull commands from file with title

commands_to_test=("sudo mount -a" "lsblk" "sha256sum *img")

for command in "${commands_to_test[@]}"; do
    memory_avg_bytes_before=$(free --bytes | rg 'Mem:' | awk '{print "Memory Usage (bytes) Before Test\nTotal\tUsed\tFree\tAvailable\n", $2, $3, $4, $6}')
    load_avg_before=$(cat /proc/loadavg)
    start=$(date +%s)
    eval "$command"
    retcode=$?
    end=$(date +%s)
    time=$(($end - $start)) # duration
    load_avg_after=$(cat /proc/loadavg) # read da load avg, number of processes, and most recent process
    memory_avg_bytes_after=$(free --bytes | rg 'Mem:' | awk '{print "Memory Usage (bytes) After Test\nTotal\tUsed\tFree\tAvailable\n", $2, $3, $4, $6}')

    echo -e "${GREEN}Completed $command\n\tTime: $time seconds\n\tStart: $start\n\tEnd: $end\n\tLoad Average Initial: $load_avg_before\n\tLoad Average After $load_avg_after\n\tRetcode $retcode${RESET}"
    echo -e "${GREEN}memory before${RESET}"
    echo -e "$memory_avg_bytes_before"
    echo -e "${GREEN}memory after${RESET}"
    echo -e "$memory_avg_bytes_after"
done
