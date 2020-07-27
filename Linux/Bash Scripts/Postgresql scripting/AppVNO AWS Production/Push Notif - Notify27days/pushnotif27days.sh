#!/usr/bin/env bash

# This script is to send notifications fro user with 27 days counter

# list.tmp path directory
fileLoc="/home/ec2-user/PushNotifcation/Notify27days/list27days.tmp"
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
# Current date + 3 days or the user expiration
expireDate=$(date --date="3 days" +"%Y-%b-%d")
# Message to the user
body="Your Philippines Mobile Number plan is about to expire on $expireDate. Please renew now to continue receiving calls and text message form Philippines."
# Logs location
logsLoc="/home/ec2-user/PushNotifcation/Notify27days/logs.tmp"
# current number
currentNumLoc="/home/ec2-user/PushNotifcation/Notify27days/currentNum.tmp"

echo "[$now] Sending notifications to mobile numbers who are about to expire..." > $logsLoc
# Python file to SELECT all id who has 27 days counter
python3 select27days.py
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
        echo "[$now] Successfully sent message to $list" >> $logsLoc
done < "$fileLoc"

# end of script
