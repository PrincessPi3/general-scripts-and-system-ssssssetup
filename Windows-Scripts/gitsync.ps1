# todo, param and defaults these up
$remote_dir = "/var/www/html/Media-Viewer"
$remote_host = "pi3"
$remote_cmd = "echo REMOTE pull $remote_dir; git -C $remote_dir pull; echo REMOTE add $remote_diradding; git -C $remote_dir add .; echo REMOTE commit $remote_dir; git -C $remote_dir commit -m `$(date +%s); echo REMOTE push $remote_dir; git -C $remote_dir push; echo -e `"\nREMOTE status $remote_dir\n`"; git -C $remote_dir status;"

echo "`nLOCAL pulling`n"
git pull

echo "`nLOCAL adding, comitting and pushing`n"
gitshit # usin gitshit here lmfao maybe make message a param

echo "`nLOCAL status`n"
git status

# run da REMOTE
echo "`nREMOTE running sync"
ssh $remote_host "/bin/bash -c $remote_cmd"

echo "`nLOCAL status`n"
git status