# /bin/bash

# First directory path
NEWIP=/home/sysnet/emailjob/new.txt
# Second directory path
LASTIP=/home/sysnet/emailjob/last.txt

if cmp -s $NEWIP $LASTIP; then
	echo "Boss parehas lang."
else
	echo "Boss magkaiba e hahaha!"
fi
