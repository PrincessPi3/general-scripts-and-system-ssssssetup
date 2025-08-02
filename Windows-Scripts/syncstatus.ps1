$remote_host = "pi3"
$remote_dir = "/var/www/html/Media-Viewer"

echo "LOCAL: pulling"
git pull

echo "LOCAL: status"
git status

ssh $remote_host "echo 'REMOTE: pulling'; git -C $remote_dir pull; echo 'REMOTE: status'; git -C $remote_dir status"