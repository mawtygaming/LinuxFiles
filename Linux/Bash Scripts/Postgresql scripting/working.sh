#!/usr/bin/env bash

database='appvno'
refLink='https://appvno-ws.multidemos.com/api/notification/send/pushNotification'
# expireDate=$(date -d "+3 days")

for list in `cat list.txt`;
do echo $list;
	result=$(curl --location --request POST $refLink \
        	--header 'Authorization: Basic YXBwdm5vdXNlcjphcHB2bm9wYXNz' \
        	--header 'Content-Type: application/json' \
        	--data-raw '{
        	"title":"27th day: Subscription is about to expire",
        	"body":"This is just a test",
		"min" :[{"mobileNumber" : "'"$list"'"}],
		"type" : "Notification",
		"action_type" : "NotificationActivity"}')
	echo "result: '$result'"
	RESP=$(echo "$result" | grep -oP "^[^a-zA-Z0-9]")
	echo "RESP:'$RESP'"
	psql -d $database -c "UPDATE notif_counter SET status='Subscribed' WHERE mobile='$list'"
done
