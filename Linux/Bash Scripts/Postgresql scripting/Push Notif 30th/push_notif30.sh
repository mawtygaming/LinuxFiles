#!/usr/bin/env bash

# Query of 30th counter location
queryLoc="/var/lib/postgresql/PushNotification/Expired30days/query30th.txt"
# txt file location
fileLoc="/var/lib/postgresql/PushNotification/Expired30days/list30days.txt"
# URL to POST request
refLink='https://appvno-ws.multidemos.com/api/notification/send/pushNotification'
# Title of Push Notification
title='30th day: Subscription Ends'
# curl type
type='Notification'
# curl action_type
actionType='NotificationActivity'
# Get the current date and time
now=$(date '+%b %d %Y %H:%M:%S')
body="Your Philippine Mobile Number plan will expire today. Please renew now to continue receiving calls and text messages from the Philippines."
# Database name
database="latest_appvno"
# Logs location
logsLoc="/var/lib/postgresql/PushNotification/Expired30days/logs.tmp"

# This is to query from appvno database writing to a file
psql -d $database -t -c "SELECT id FROM svn WHERE expiry_date::DATE = current_date" > $queryLoc
# Deleting the last line from list.txt
sed '$d' $queryLoc > $fileLoc
echo "[$now] Sending notifications to mobile numbers with 30th day counter." > $logsLoc

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
	echo "[$now] Successfully sent expire notification to $list" >> $logsLoc
done < "$fileLoc"
