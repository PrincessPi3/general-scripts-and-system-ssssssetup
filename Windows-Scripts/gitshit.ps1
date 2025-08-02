if ($args) {
    $message=$args -join ' '
} else {
    if(test-path './version.txt') {
        $message = $(get-content './version.txt')
    } else {
        $message = $(Get-Date -uformat "%s")
    }
}

echo "git commit message: '$message'"

git add .
git commit -m "$message"
git push

echo "Done :3"