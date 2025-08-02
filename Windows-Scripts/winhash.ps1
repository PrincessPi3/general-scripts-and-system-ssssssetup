# Usage:
## .\winhash.ps1 <FILE> <ALGO>
## Algos Supported:
### MD5
### SHA1
### SHA256
### SHA384
### SHA512
## Example:
### .\winhash.ps1 sillyfilly.bin SHA256
## Outputs to terminal and to a text file
### Text file name format <input filepath>.<unix epoch microseconds>.<hashing algorithm>.txt

param (
    [Parameter(Mandatory=$true)] # prompt for input if not specified via cli
    [string]$infile,

    [Parameter(Mandatory=$true)] # this 1 2 :pope:
    [string]$algo
)

function Get-UnixMicroseconds {
    $unixEpoch = [DateTimeOffset]'1970-01-01T00:00:00Z' # unix epoch constant
    $currentTime = [DateTimeOffset]::UtcNow # current utc time
    $timeDifferenceTicks = $currentTime.Ticks - $unixEpoch.Ticks # subtract current time from unix epoch constant in ticks
    $microseconds = [Int64]($timeDifferenceTicks / 10) # use 64bit int, divide ticks by 10 to give microseconds

    # I am literally using Unix microseconds because they are more fun than Unix seconds :pinkie:
    return $microseconds
}

# jesus fuckin analbeads the selection of hash algos in powershell is weird and limited
# probably because Bill Gates and Satya Nadella get together with the other C-suite executives
# and hypergoon to leagelese in clickwrap agreements that absolves them of liability and
# lets them sell our private data and other assorted dickpics or sumtin idk man lmao
$hash = $(Get-FileHash -Path $infile -Algorithm $algo | Format-List) # do da fookin hashin right dafucc here
echo $hash # show user
echo $hash > "$infile.$(Get-UnixMicroseconds).$algo.txt" # make the txt file