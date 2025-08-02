# `pwsh.exe -c "`"C:\path\to\redundant-backup.ps1`" -logFile `"`" -simpleLogFile `"`""`
# `Start-Process -filepath "C:\path\to\redundant-backup.ps1" -logFile "" -simpleLogFile ""`
# `redundant-backup -logFile "" -simpleLogFile ""`
param([string] $logFile,
    [string] $simpleLogFile
)

$startUnixSeconds = get-date -uformat "%s" # unix epoch seconds for duration
$startDateHuman = get-date # human readable begin date
$startDateFilename = get-date -format 'yyyy-MM-dd-hhmm' # filename friendly date format


$warningFile = "C:\Users\human\OneDrive\Desktop\backup_error_$startDateFilename.log" # file to create to notify of a failure

$jobName = "Weekly-Backup-$startDateFilename" # name for job in case wanna restart an interrupted one
$resticRunning = "E:\restic_backups_rolling" # from dir (restic)

$redundantLocal = "D:\restic_backups_redundancy_rolling" # to dir (local drive)
$redundantLocalNetwork = "R:\restics_backups_redundancy_rolling" # to dir (network mapped drive location)
$redundantAirGap = "S:\restic_backups_redundancy_rolling" # set backup usb to use S

$logGuideString = "Verb | Current Date and Time (Current Time Unix Seconds) | Start Date and Time (Start Time Unix Seconds) | Time Elapsed in Seconds | From Directory | To Directory | Job Name | Exit Status"

function appendToLog {
    param([string]$verb="INFO", [string]$exitCode="NONE", [string]$log="$logFile", [string]$fromDir="NONE", [string]$toDir="NONE")

    $timeCalc = $(Get-Date -uformat "%s")-$startUnixSeconds

    # Verb | Current Date and Time (Current Time Unix Seconds) | Start Date and Time (Start Time Unix Seconds) | Time Elapsed in Seconds | From Directory | To Directory | Job Name | Exit Status
    $logString = "$verb | $(Get-Date) ($(Get-Date -uformat "%s")) | $startDateHuman ($startUnixSeconds) | $timeCalc | $fromDir | $toDir | $jobName | $exitCode"

    echo "$logString"
    echo "$logString" >> "$log"
}

function appendToErrorLog {
    param  ( $exceptionMessage, $part )
    $errorString = "`nFAIL on $part`nException: $exceptionMessage`nVars:`n`tstartDateHuman: $startDateHuman`n`tstart: $startUnixSecondsUnixSecons`n`tappendToErrorLog: $appendToErrorLog`n`tlogFile: $logFile`n`twarningFile: $warningFile`n`tresticRunning: $resticRunning`n`tredundantLocal: $redundantLocal`n`tredundantLocalNetwork: $redundantLocalNetwork`n`tjobName: $jobName"

    echo "$errorString"
    try { echo "$errorString" > "$warningFile" } catch { echo "Error: $warningFile Not Found" }
}

function doBackup {
    param ( [string]$fromDir="NONE", [string]$toDir="NONE", [string]$tagString="INFO" )
    
    echo "`n$tagString"
    echo "`tFollow log with:`n`t`tGet-Content `"$logFile`" -Wait -Tail 10`n"
    
    appendToLog -verb "START-$tagString" -log "$logFile" -toDir "$toDir" -fromDir "$fromDir"
    robocopy "$fromDir" "$toDir" /E /Z /FP /NP /R:2 /W:1 /SAVE:"$jobString" /LOG+:"$logFile"
    appendToLog -verb "FINISH-$tagString" -exitCode "$?" -log "$logFile" -toDir "$toDir" -fromDir "$fromDir"
}

echo "Initializing Logs"

touch "$runningFile"

echo "$logGuideString" > "$logFile"
appendToLog -verb "INITIALIZE-LOG-FILES" -exitCode "$?" -log "$logFile"

echo "`n$logGuideString`n"

# run da backupssss
doBackup -fromDir "$resticRunning" -toDir "$redundantLocal" -tagString "COPY-LOCAL" -jobString "$jobName" # local
appendToLog -verb "COPY-LOCAL" -exitCode "$?" -log "$logFile" -fromDir "$resticRunning" -toDir "$redundantLocal"

doBackup -fromDir "$resticRunning" -toDir "$redundantLocalNetwork" -tagString "COPY-LOCAL-NETWORK" -jobString "$jobName" # network
appendToLog -verb "COPY-LOCAL-NETWORK" -exitCode "$?" -log "$logFile" -fromDir "$resticRunning" -toDir "$redundantLocalNetwork"

doBackup -fromDir "$resticRunning" -toDir "$redundantAirGap" -tagString "COPY-AIRGAP" -jobString "$jobName" # airgap
appendToLog -verb "COPY-AIRGAP" -exitCode "$?" -log "$logFile" -fromDir "$resticRunning" -toDir "$redundantAirGap"

appendToLog -verb "DONE" -log "$logFile"