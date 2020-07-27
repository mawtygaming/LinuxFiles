#!/usr/bin/env bash

# This script is to send notification and update tables svn and users and insert into svn_transactions
# to users with mobile number who has 91 days counter.

# list.tmp path directory
fileLoc="/home/ec2-user/PushNotification/Deactivated91days/list91days.tmp"
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
# Message to the user
body="Your Philippine Mobile Number subscription is now deactivated. A new mobile number will be assigned to you after subscribing to a new plan."
# Logs location
logsLoc="/home/ec2-user/PushNotification/Deactivated91days/logs.tmp"
# current number
currentNumLoc="/home/ec2-user/PushNotification/Deactivated91days/currentNum.tmp"

echo "[$now] Sending notifications to mobile numbers advising today is the last day of grace period..." > $logsLoc
# Python file to SELECT all id who has 34 days counter
python3 select91days.py
# psql -d $database -t -c "SELECT id FROM svn WHERE current_date - expiry_date::DATE =61" 
# psql must be setup using .pgpass for postgresql authentication, please indicated database
# name and query list directory. Deleting the last line from list.tmp

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
# Updating svn_id into null
		echo "[$now] Successfully sent svn number deactivation notice to $list" >> $logsLoc
		python3 updateQuery91.py
done < "$fileLoc"

# end of script

