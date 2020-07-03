import requests
import sys

url = "https://appvno-ws.multidemos.com/api/notification/send/pushNotification"

payload = "{\r\n\"title\":\"27th day: Subscription is about to expire\",\r\n\"body\":\"Your Philippines Mobile Number plan is about to expire on 01/01/2121.Please renew now to continue receiving calls and text message form Philippines.\",\r\n\"min\" : [\r\n {\r\n \"mobileNumber\" : \"639662146331\"\r\n },\r\n {\r\n \"mobileNumber\" : \"639675156231\"\r\n }\r\n ],\r\n\"type\" : \"Notification\",\r\n\"action_type\" : \"NotificationActivity\"\r\n}"
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
