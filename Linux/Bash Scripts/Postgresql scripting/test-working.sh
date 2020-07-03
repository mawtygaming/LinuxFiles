#!/usr/bin/env bash

database='appvno'
refLink='https://appvno-ws.multidemos.com/api/notification/send/pushNotification'
time=$(date +"%A  %B-%d-%Y %r")

for list in `cat list.txt`;
do
	response=$(curl --location --request POST $refLink \
        	--header 'Authorization: Basic YXBwdm5vdXNlcjphcHB2bm9wYXNz' \
        	--header 'Content-Type: application/json' \
        	--data-raw '{
        	"title":"27th day: Subscription is about to expire",
        	"body":"This is just a test",
		"min" :[{"mobileNumber" : "'"$list"'"}],
		"type" : "Notification",
		"action_type" : "NotificationActivity"}')
# Echo mobile number
	echo "[$time] Mobile Number: $list" >> logs.txt
# Echo response from curl
	echo "Response: '$response'"
	echo "[$time] Result: '$response'" >> logs.txt

	echo $list > currentNum.txt
	sleep 2s
	python3 updateQuery.py
done
