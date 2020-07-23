#!/usr/bin/env bash

# Query of 31th counter location
queryLoc="/var/lib/postgresql/PushNotification/IncomingOnly34days/query34th.txt"
# txt file location
fileLoc="/var/lib/postgresql/PushNotification/IncomingOnly34days/list34days.txt"
now=$(date '+%b %d %Y %H:%M:%S')
# URL to POST request
refLink='https://appvno-ws.multidemos.com/api/notification/send/pushNotification'
# Title of Push Notification
title='34th day: Grace Period is about to end'
# curl type
type='Notification'
# curl action_type
actionType='NotificationActivity'
# message
body="Subscribe to the Philippine Mobile Number plan now to continue receiving calls and texts and sending text messages to the Philippines."
# Database name
database="appvno_latest"
# Logs location
logsLoc="/var/lib/postgresql/PushNotification/IncomingOnly34days/logs.tmp"
# current number
currentNumLoc="/var/lib/postgresql/PushNotification/IncomingOnly34days/currentNum.txt"

# This is to query from appvno database writing to a file
psql -d $database -t -c "SELECT id FROM svn WHERE current_date - expiry_date::DATE = 4" > $queryLoc
# Deleting the last line from list.txt
sed '$d' $queryLoc > $fileLoc
echo "[$now] Sending notifications to mobile numbers to be expired" > $logsLoc

# This is to read the textfile list.txt line per line
while IFS='' read -r list;
# for list in `cat list.txt`;
do
# curl POST request
        response=$(curl --location --request POST $refLink \
                --header 'Authorization: Basic YXBwdm5vdXNlcjphcHB2bm9wYXNz' \
                --header 'Content-Type: application/json' \
                --data-raw '{
                "title":"'"$title"'",
                "body":"'"$body"'",
                "min" :[{"mobileNumber" : "'"$list"'"}],
                "type" : "'"$type"'",
                "action_type" : "'"$actionType"'"}')
# Echo mobile number
        echo "[$now] Mobile Number: $list" >> $logsLoc
# Response
		echo "Response: '$response'"
        echo "[$now] Result: '$response'" >> $logsLoc
# Update the current number of the list
        echo $list > $currentNumLoc
		echo "[$now] Updating $list status into EXPIRED" >> $logsLoc
# Run updateQuery.py using python to update status into INACTIVE
        python3 updateQuery34.py
done < "$fileLoc"
