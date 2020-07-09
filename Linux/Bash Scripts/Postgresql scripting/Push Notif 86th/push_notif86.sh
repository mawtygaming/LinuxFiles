#!/usr/bin/env bash

# Query of 86th counter location
queryLoc="/var/lib/postgresql/PushNotification/Cooling86days/query86th.txt"
# txt file location
fileLoc="/var/lib/postgresql/PushNotification/Cooling86days/list86days.txt"
# URL to POST request
refLink='https://appvno-ws.multidemos.com/api/notification/send/pushNotification'
# Title of Push Notification
title='86th day: Last Day Of Cooling Period'
# curl type
type='Notification'
# curl action_type
actionType='NotificationActivity'
# Get the current date and time
now=$(date '+%b %d %Y %H:%M:%S')
body="Your Philippine Mobile Number subscription is about to be deactivated. Subscribe to a new plan now to retain your existing number."
# Database name
database="latest_appvno"
# Logs location
logsLoc="/var/lib/postgresql/PushNotification/Cooling86days/logs.tmp"

# This is to query from appvno database writing to a file
psql -d $database -t -c "SELECT id FROM svn WHERE current_date - expiry_date::DATE = 56;" > $queryLoc
# Deleting the last line from list.txt
sed '$d' $queryLoc > $fileLoc
echo "[$now] Sending notifications to mobile numbers with 86th day counter." > $logsLoc

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
# Echo response from curl
        echo "Response: '$response'"
        echo "[$now] Result: '$response'" >> $logsLoc
# Wait for 2 seconds
        sleep 2s
	echo "[$now] Successfully sent last day of cooling period notification to $list" >> $logsLoc
done < "$fileLoc"
