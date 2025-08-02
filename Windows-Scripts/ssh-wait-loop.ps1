param(
    [string] 
    $session = 'pi3'
)

while($True) {
    ssh $session
    echo "Waiting 5 Seconds..." 
    sleep 5
    wait-on-host -hostname $session
}