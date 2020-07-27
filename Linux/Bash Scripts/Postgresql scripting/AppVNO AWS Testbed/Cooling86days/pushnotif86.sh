#!/usr/bin/env bash

# list.tmp path directory
fileLoc="/home/ec2-user/PushNotification/Cooling86days/list86days.tmp"
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
# Message to the user
body="Your Philippine Mobile Number subscription is about to be deactivated. Subscribe to a new plan now to retain your existing number."
# Logs location
logsLoc="/home/ec2-user/PushNotification/Cooling86days/logs.tmp"

echo "[$now] Sending notifications to mobile numbers advising that today is the last day of cooling period..." > $logsLoc
# Python file to SELECT all id who has 86 days counter
python3 select86days.py
# psql -d $database -t -c "SELECT id FROM svn WHERE expiry_date::DATE - current_date = 3" psql must be setup using .pgpass for postgresql authentication, please indicated database
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
        echo "[$now] Successfully sent last day of cooling period notification to $list" >> $logsLoc
done < "$fileLoc"

# end of script

