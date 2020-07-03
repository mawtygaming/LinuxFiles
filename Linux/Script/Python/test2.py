import requests
import sys
import json

list = open('list.txt')
perline = list.readline()

while perline:
	print(perline)
	perline = list.readline()
	url = "https://appvno-ws.multidemos.com/api/notification/send/pushNotification"

	payload = {"title": "27th day: Subscription is about to expire",
			"body": "Your Philippines Mobile Number plan is about to expire on 01/01/2121.Please renew now to continue receiving calls and text message form Philippines.",
			"min" : [{"mobileNumber" : "str(perline)"}],
			"type" : "Notification",
			"action_type" : "NotificationActivity"}
	headers = {
	'Authorization': 'Basic YXBwdm5vdXNlcjphcHB2bm9wYXNz',
	'Content-Type': 'application/json'
	}

	response = requests.request("POST", url, headers=headers, data = payload)

	original_stdout = sys.stdout

	with open('logs.txt', 'w') as logs:
		sys.stdout = logs
		print(response.text.encode('utf8'))
		sys.stdout = original_stdout
list.close()
