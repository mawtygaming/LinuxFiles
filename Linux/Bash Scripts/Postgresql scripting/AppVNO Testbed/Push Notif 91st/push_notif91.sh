#!/usr/bin/env bash

# Query of 91st counter location
queryLoc="/var/lib/postgresql/PushNotification/Deactivated91days/query91st.txt"
# txt file location
fileLoc="/var/lib/postgresql/PushNotification/Deactivated91days/list91days.txt"
# URL to POST request
refLink='https://appvno-ws.multidemos.com/api/notification/send/pushNotification'
# Title of Push Notification
title='91st day: Deactivated Philippine Number'
# curl type
type='Notification'
# curl action_type
actionType='NotificationActivity'
# Get the current date and time
now=$(date '+%b %d %Y %H:%M:%S')
body="Your Philippine Mobile Number subscription is now deactivated. A new mobile number will be assigned to you after subscribing to a new plan."
# Database name
database="appvno_latest"
# Logs location
logsLoc="/var/lib/postgresql/PushNotification/Deactivated91days/logs.tmp"
# current number
currentNumLoc="/var/lib/postgresql/PushNotification/Deactivated91days/currentNum.txt"

# This is to query from appvno database writing to a file
psql -d $database -t -c "SELECT id FROM svn WHERE current_date - expiry_date::DATE =61" > $queryLoc
# Deleting the last line from list.txt
sed '$d' $queryLoc > $fileLoc
echo "[$now] Sending notifications to mobile number/s regarding the svn number expiration" > $logsLoc

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
# Update the current number of the list
        echo $list > $currentNumLoc
# Wait for 2 seconds
		echo "[$now] Successfully sent svn number deactivation notice to $list" >> $logsLoc
# Run updateQuery.py using python to update svn_id into NULL
        python3 updateQuery91.py
done < "$fileLoc"
