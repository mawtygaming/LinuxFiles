#!/usr/bin/env bash

# list.tmp path directory
fileLoc="/home/ec2-user/PushNotifcation/Inactive31days/list31days.tmp"
# Get the current date and time
now=$(date '+%b %d %Y %H:%M:%S')
# Logs location
logsLoc="/home/ec2-user/PushNotifcation/Inactive31days/logs.tmp"
# current number
currentNumLoc="/home/ec2-user/PushNotifcation/Inactive31days/currentNum.tmp"

echo "[$now] Sending notifications to mobile numbers who are about to expire..." > $logsLoc
# Python file to SELECT all id who has 27 days counter
python3 select31days.py
# psql -d $database -t -c "SELECT id FROM svn WHERE current_date - expiry_date::DATE = 1" psql must be setup using .pgpass for postgresql authentication, please indicated database
# name and query list directory. Deleting the last line from list.txt

# This is to read the textfile list.txt line per line
while IFS='' read -r list;
# for list in `cat list.txt`;
do
# Echo mobile number
        echo "[$now] Mobile Number: $list" >> $logsLoc
        echo "[$now] Updating $list status into INCOMING_SMS_ONLY" >> $logsLoc
#		python3 updateQuery31.py
done < "$fileLoc"

# end of script
