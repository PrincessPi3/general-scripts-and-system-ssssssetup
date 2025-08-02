# usage:
#   `.\wait-on-host.ps1 -hostname <DOMAIN_NAME_OR_IP> -sleep <SECONDS_TO_SLEEP_PER_CYCLE> -pingcount <NUMBER_OF_TIMES_TO_PING_PER_ITERATION> -max <MAX_NUMBER_OF_ITERATIONS> -hold <SECONDS_TO_WAIT_AFTER_FIRST_RESPONSE>`
#
#   defaults:
#       hostname: cable-wind.local
#       sleep: 25
#       pingcount: 1
#       max: 500
#       hold: 30
#       ex. `.\wait-on-host.ps1 -hostname google.com -sleep 10 -pingcount 5`



param(
    [string]
    $hostname = "cable-wind.local",

    [int]
    $sleep = 25,

    [int]
    $pingcount = 1,

    [int]
    $max = 500,

    [bool]
    $loop = 0, # 1 to loop

    [int]
    $hold = 30
)

if($hostname -eq 'help') {
    echo "usage:`n`twait-on-host [help] -hostname <DOMAIN_NAME_OR_IP> -sleep <SECONDS_TO_SLEEP_PER_CYCLE> -pingcount <NUMBER_OF_TIMES_TO_PING_PER_ITERATION> -max <MAX_NUMBER_OF_ITERATIONS> -hold <SECONDS_TO_WAIT_AFTER_FIRST_RESPONSE>`n`twait-on-host help`n`t`tthis help message`n`twait-on-host 8.8.8.8`n`t`twait on 8.8.8.8 with defaults`n`tdefaults:`n`t`thostname: cable-wind.local`n`t`tsleep: 25`n`t`tpingcount: 1`n`t`tmax: 500`n`t`thold: 30`n`tex. wait-on-host -hostname google.com -sleep 10 -pingcount 5`n";
    
    exit;
}

$iterations = 0;

while(1 -eq 1) {  # infinite loop
    echo "`nHost: $hostname" # Iterations: $iterations Count: $pingcount Sleep: $sleep Max: $max`n`tFlushing dns..."
    echo "`tFlushing DNS"
    ipconfig /flushdns >NUL 2>&1 # redirects output nowhere
    if($?) {
        echo "`t`tDone."
    } else {
        echo "`t`tFAILED TO FLUSH DNS! EXITING!"
        exit
    }

    echo "`tPinging..."
    # $pingObj = Test-Connection -Count $pingcount -TargetName "$hostname" # powershell Test-Connection -Ping is default and redundant
    $pingObj = Test-Connection -Count $pingcount -TargetName "$hostname" 2>&1

    if($pingObj.Status -eq "Success") { # if return status of abopve (ping -n 1...) is True
        # $pingObj = Test-Connection -Count $pingcount -TargetName "$hostname" # powershell Test-Connection -Ping is default and redundant
        $ip = $pingObj.Address.IPAddressToString # get the bare ip out

        echo "`t`tSuccess!`n`t`tIP: $ip`n`t`tHost: $hostname`n`t`tURL (host): http://$hostname`n`t`tURL (IP): http://$ip"
        if($loop) {
            echo "Sleeping $sleep Seconds..."
            sleep $sleep # sleepy time
        } else {
            echo "`nWaiting $hold Seconds to Make Sure..."
            sleep $hold
            echo "`nReady!`n"
            break
        }
    } else {
        echo "`t`tNOT FOUND YET"
        echo "`nSleeping $sleep Seconds..."
        sleep $sleep # sleepy time
    }


    if($iterations -gt $max) {
        echo "`nMAX ITERATIONS OF $max REACHED! EXITINTG`n"
        exit
    }

    $iterations++

}