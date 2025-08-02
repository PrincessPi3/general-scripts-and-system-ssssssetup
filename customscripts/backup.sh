#!/bin/bash
[ "root" != "$USER" ] && exec sudo $0 "$@"
LOCK=/var/lock/backups.lock
if [ ! -f $LOCK ]; then
echo "lock" > $LOCK
rsync -rzvvb --backup-dir=_old_ --suffix=$(date+_%F-%T) --update --times -e ssh /home/ <username>@<server>:~/backups/home
rm -f $LOCK
fi