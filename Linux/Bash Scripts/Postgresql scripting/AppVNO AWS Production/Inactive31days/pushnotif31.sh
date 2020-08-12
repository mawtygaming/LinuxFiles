#!/usr/bin/env bash

# list.tmp path directory
fileLoc="/home/ec2-user/PushNotifcation/Inactive31days/list31days.tmp"
# Get the current date and time
now=$(date '+%b %d %Y %H:%M:%S')
# Logs location
logsLoc="/home/ec2-user/PushNotifcation/Inactive31days/logs.tmp"
# current number
currentNumLoc="/home/ec2-user/PushNotifcation/Inactive31days/currentNum.tmp"

echo "[$now] Updating mobile numbers who will be inactive..." > $logsLoc
# Python file to SELECT all id who has 27 days counter
cd /home/ec2-user/PushNotifcation/Inactive31days/
./select31days.py
# psql -d $database -t -c "SELECT id FROM svn WHERE current_date - expiry_date::DATE = 1" psql must be setup using .pgpass for postgresql authentication, please indicated database
# name and query list directory. Deleting the last line from list.txt

# This is to read the textfile list.txt line per line
while IFS='' read -r list;
#for list in `cat list31days.tmp`;
do
# Echo current number
        echo $list > $currentNumLoc
# Echo mobile number
        echo "[$now] Mobile Number: $list" >> $logsLoc
        echo "[$now] Updating $list status into INCOMING_SMS_ONLY" >> $logsLoc
	cd /home/ec2-user/PushNotifcation/Inactive31days/
	./updateQuery31.py
done < "$fileLoc"

# end of script
