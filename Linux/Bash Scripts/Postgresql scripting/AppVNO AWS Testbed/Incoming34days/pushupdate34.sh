#!/usr/bin/env bash

# list.tmp path directory
fileLoc="/home/ec2-user/PushNotification/Incoming34days/list34days.tmp"
# URL to POST request
refLink='https://appvno-ws.multidemos.com/api/notification/send/pushNotification'
# Title of Push Notification
title='34th day: Grace Period is about to end'
# curl type
type='Notification'
# curl action_type
actionType='NotificationActivity'
# Get the current date and time
now=$(date '+%b %d %Y %H:%M:%S')
# Message to the user
body="Subscribe to the Philippine Mobile Number plan now to continue receiving calls and texts and sending text messages to the Philippines."
# Logs location
logsLoc="/home/ec2-user/PushNotification/Incoming34days/logs.tmp"
# current number
currentNumLoc="/home/ec2-user/PushNotification/Incoming34days/currentNum.tmp"

echo "[$now] Sending notifications to mobile numbers advising today is the last day of grace period..." > $logsLoc
# Python file to SELECT all id who has 34 days counter
python3 select34days.py
# psql -d $database -t -c "SELECT id FROM svn WHERE current_date - expiry_date::DATE = 4" psql must be setup using .pgpass for postgresql authentication, please indicated database
# name and query list directory. Deleting the last line from list.txt

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
        echo "[$now] Updating $list status into EXPIRED" >> $logsLoc
# Updating status into EXPIRED
	python3 updateQuery34.py
done < "$fileLoc"

# end of script

