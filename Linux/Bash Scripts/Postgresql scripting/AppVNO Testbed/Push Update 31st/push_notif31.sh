#!/usr/bin/env bash

# Query of 31th counter location
queryLoc="/var/lib/postgresql/PushNotification/Inactive31days/query31st.txt"
# txt file location
fileLoc="/var/lib/postgresql/PushNotification/Inactive31days/list31days.txt"
now=$(date '+%b %d %Y %H:%M:%S')
# Database name
database="appvno_latest"
# Logs location
logsLoc="/var/lib/postgresql/PushNotification/Inactive31days/logs.tmp"
# current number
currentNumLoc="/var/lib/postgresql/PushNotification/Inactive31days/currentNum.txt"

# This is to query from appvno database writing to a file
psql -d $database -t -c "SELECT id FROM svn WHERE current_date - expiry_date::DATE = 1" > $queryLoc
# Deleting the last line from list.txt
sed '$d' $queryLoc > $fileLoc
echo "[$now] Sending notifications to mobile numbers with Outgoing SMS/Calls and Incoming calls are disabled" > $logsLoc

# This is to read the textfile list.txt line per line
while IFS='' read -r list;
# for list in `cat list.txt`;
do
# Echo mobile number
        echo "[$now] Mobile Number: $list" >> $logsLoc
# Update the current number of the list
        echo $list > $currentNumLoc
	echo "[$now] Updating $list status into INCOMING_SMS_ONLY" >> $logsLoc
# Run updateQuery.py using python to update status into INACTIVE
        python3 updateQuery31.py
done < "$fileLoc"
