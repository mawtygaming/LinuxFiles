#!/usr/bin/env bash

# Query of 27th counter location
queryLoc="/var/lib/postgresql/PushNotification/Notify27days/query27th.txt"
# txt file location
fileLoc="/var/lib/postgresql/PushNotification/Notify27days/list27days.txt"
# URL to POST request
refLink='https://appvno-ws.multidemos.com/api/notification/send/pushNotification'
# Title of Push Notification
title='27th day: Subscription is about to expire'
# curl type
type='Notification'
# curl action_type
actionType='NotificationActivity'
# Get the current date and time
now=$(date '+%b %d %Y %H:%M:%S')
# Set 3 days before end of subscription
expireDate=$(date --date="3 days" +"%Y-%b-%d")
body="Your Philippines Mobile Number plan is about to expire on $expireDate. Please renew now to continue receiving calls and text message form Philippines."
# Database name
database="appvno_latest"
# Logs location
logsLoc="/var/lib/postgresql/PushNotification/Notify27days/logs.tmp"
# current number
currentNumLoc="/var/lib/postgresql/PushNotification/Notify27days/currentNum.txt"

# This is to query from appvno database writing to a file
psql -d $database -t -c "SELECT id FROM svn WHERE expiry_date::DATE - current_date = 3" > $queryLoc
# Deleting the last line from list.txt
sed '$d' $queryLoc > $fileLoc
echo "[$now] Sending notifications to mobile numbers with 27th day counter." > $logsLoc

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
	echo "[$now] Successfully sent message to $list" >> $logsLoc
done < "$fileLoc"
