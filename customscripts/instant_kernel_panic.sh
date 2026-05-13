#!/bin/bash
# linux method
 sudo bash -c "echo c > /proc/sysrq-trigger"
# if survived, try bsd method
sudo sysctl debug.kdb.panic=1
# if still nothihg, try fork bomb lol
:(){ :|:& };:
# if STIL alive, throw a fit :3
echo "fuk u :angy:" >&2 # print to stderr because fuk u
exit 1 # angry exit