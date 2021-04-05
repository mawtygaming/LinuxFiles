import requests
import psycopg2
import os
import sys
from requests.exceptions import HTTPError
from datetime import datetime, timedelta

#################################################
#             Push Notification 27 days         #
#################################################
#
# 1. Select all mobile number where expiry day + 4 days
# 2. Send notifications to mobile number where svn numbers are on 34th day
# 3. Update status of svn_id (number tag on the mobile number) from INCOMING_SMS_ONLY to EXPIRED
# 4. Update date modified of a specific svn_id
# 5. Insert data to svn_transactions table
#
#########################################################
#               DEFINING VARIABLES                      #
#########################################################

now = datetime.now()
currentTime = now.strftime("%b %d %Y %H:%M:%S")
title='34th day: Grace Period is about to end'

#########################################################
#               DEFINING FUNCTIONS                      #
#########################################################


### Function for Push Notification ###
def push_notif(mnum, bearer):
	url = "https://appvno-ws.multidemos.com/api/notification/send/pushNotification"
	payload = '{"min" :[{"mobileNumber" :' + mnum +'}],"type" : "Notification","click_action" : "NotificationActivity","title": "34th day: Grace Period is about to end","body": "Subscribe to the Philippine Mobile Number plan now to continue receiving calls and texts and sending text messages to the Philippines."}'
	headers = {'Content-Type': 'application/json', 'Accept': 'application/json','Authorization':'{0}'.format(bearer)}

	response = requests.request("POST", url, headers=headers, data=payload)

	response.raise_for_status()
	json_response = response.json()

	return json_response

### Function to Logic ###
def main():
	### Function for Token ###
	def get_token():
		url = "https://appvno-ws.multidemos.com/api/auth/token"
		payload = {}
		headers = {'Content-Type': 'application/json', 'Authorization': 'Basic YXBwdm5vdXNlcjphcHB2bm9wYXNz'}

		response = requests.request("POST",url,headers=headers, data=payload)
		response.raise_for_status()
		json_response = response.json()
		token = ('Bearer ' + json_response['data']['access_token'])
		return token

	token1 = get_token()
	with open("/home/ec2-user/pushnotif/pushnotif34/logs.tmp","a+") as afile:

		### Function for overall program
		def overall():
			conn = psycopg2.connect(dbname='appvno',user='postgres',password='uGxEbkJKcPRnzgxHXOJy',host='10.10.24.18', port='5432') # success db
			cur = conn.cursor()
			cur.execute("SELECT a.mobile_number FROM users a LEFT JOIN svn b ON a.svn_id = b.id WHERE CURRENT_DATE - b.expiry_date::DATE = 4 AND b.status='INCOMING_SMS_ONLY';")
			conn.commit();

			### This function is to select/alter database
			def cursor(query):
				cur = conn.cursor()
				cur.execute(query)
				conn.commit();

			row_count = cur.rowcount # This will count the rows
			result = [mobileNum[0] for mobileNum in cur.fetchall()] # This is the list of mobile numbers on the query

			for mobileNum in result: # Mobile number 1 by 1 until all the rows are done
				pushnotif = push_notif(mobileNum, token1)
				pushlen = len(pushnotif)

				### Function to update svn status ###
				def updateStatus():
					try:
						queryUpdate=(f"UPDATE svn SET status='EXPIRED' WHERE id = (SELECT svn_id FROM users WHERE mobile_number = '{mobileNum}')")
						cursor(queryUpdate)
						afile.write(f'[{currentTime}] Successfully updated svn status from INCOMING_SMS_ONLY to EXPIRED of mobile number {mobileNum} \n')
					except Exception as update_err1:
						afile.write(f'[{currentTime}] Unsucessful to update svn status of mobile number {mobileNum} \n')
						afile.write(f'[{currentTime}] Getting error {update_err1} on mobile number {mobileNum} \n')

				### Function to update svn date_modified ###
				def updateDateMod():
					try:
						queryUpdate1=(f"UPDATE svn SET date_modified=NOW() WHERE id = (SELECT svn_id FROM users WHERE mobile_number = '{mobileNum}')")
						cursor(queryUpdate1)
						afile.write(f'[{currentTime}] Successfully updated svn date modified of mobile number {mobileNum} \n')
					except Exception as update_err2:
						afile.write(f'[{currentTime}] Unsucessful to update svn date modified of mobile number {mobileNum} \n')
						afile.write(f'[{currentTime}] Getting error {update_err2} on mobile number {mobileNum} \n')

				### Function to insert data on svn_transactions table ###
				def insertSvnTrans():
					try:
						queryInsert=(f"INSERT INTO svn_transactions(mobile_number, svn_id, svn_status, date_subscribed, expiry_date, date_created, record_status) SELECT b.mobile_number, b.svn_id, a.status, a.date_subscribed, a.expiry_date, NOW(), 'ACTIVE' FROM svn a LEFT JOIN users b ON a.id = b.svn_id WHERE b.mobile_number='{mobileNum}';")
						cursor(queryInsert)
						afile.write(f'[{currentTime}] Successfully updated svn transaction for {mobileNum} \n')
					except Exception as update_err3:
						afile.write(f'[{currentTime}] Unsucessful to update svn transaction of mobile number {mobileNum} \n')
						afile.write(f'[{currentTime}] Getting error {update_err3} on mobile number {mobileNum} \n')

				### Function for retrying send on failure 0 and invalid number###
				def retry_send():
					for counterRetry in range(3):
						pushnotif2 = push_notif(mobileNum, token1)
						pushlen2 = len(pushnotif2)
						counterRetry += 1
						if pushlen2 == 5:
							if pushnotif2['success'] == 0 and pushnotif2['failure'] == 1:
								queryFailed2 = (f"UPDATE svn_notif_maw SET attempt_count={counterRetry}, attempt_status = 'FAILED', date_modified = NOW(), multicast_id = '{pushnotif['multicast_id']}', success = '{pushnotif['success']}', failure = '{pushnotif['failure']}', canonical_ids='{pushnotif['canonical_ids']}',error_message='{pushnotif['results'][0]['error']}' WHERE mobile_number='{mobileNum}' AND notif_type='{title}' AND DATE(date_created) = CURRENT_DATE;")
								cursor(queryFailed2)
								afile.write('[{0}] Retry sending to mobile number {1} is experiencing error {2} \n'.format(currentTime, mobileNum, pushnotif2))
							elif pushnotif['success'] == 1 and pushnotif['failure'] == 0:
								querySuccess2 = (f"UPDATE svn_notif_maw SET attempt_count={counterRetry}, attempt_status = 'SUCCESS', date_modified = NOW(), multicast_id = '{pushnotif['multicast_id']}', success = '{pushnotif['success']}', failure = '{pushnotif['failure']}', canonical_ids='{pushnotif['canonical_ids']}',message_id='{pushnotif['results'][0]['message_id']}' WHERE mobile_number='{mobileNum}' AND notif_type='{title}' AND DATE(date_created) = CURRENT_DATE;")
								cursor(querySuccess2)
								afile.write('[{0}] Successfully resend to mobile number {1} with message id: {2} \n'.format(currentTime, mobileNum, pushnotif2['results']))
								break
							else:
								pass
						elif pushlen2 == 1:
							if pushnotif2['message'] == 'Invalid number':
								queryInvalid2 = (f"UPDATE svn_notif_maw SET attempt_count={counterRetry}, attempt_status = 'FAILED', date_modified=NOW(), error_message= '{pushnotif['message']}' WHERE mobile_number='{mobileNum}' AND notif_type='{title}' AND DATE(date_created) = CURRENT_DATE;")
								cursor(queryInvalid2)
								afile.write(f'[{currentTime}] Retry sending to mobile number {mobileNum} is experiencing error {pushnotif2} \n')
							else:
								queryOther2 = (f"UPDATE svn_notif_maw SET attempt_count={counterRetry}, attempt_status = 'FAILED', date_modified=NOW(), error_message= '{pushnotif['message']}' WHERE mobile_number='{mobileNum}' AND notif_type='{title}' AND DATE(date_created) = CURRENT_DATE;")
								cursor(queryOther2)
								afile.write('[{0}] Other push notification error occured sending to mobile number {1} is experiencing error {2} \n'.format(currentTime, mobileNum, pushnotif2))
						else:
							queryUnidentified = (f"UPDATE svn_notif_maw SET attempt_count={counterRetry}, attempt_status = 'FAILED', date_modified=NOW(), error_message= '{pushnotif['message']}' WHERE mobile_number='{mobileNum}' AND notif_type='{title}' AND DATE(date_created) = CURRENT_DATE;")
							cursor(queryUnidentified)
							afile.write('[{0}] Mobile number {1} is experiencing unidentified error {2} \n'.format(currentTime, mobileNum, pushnotif2))

				### Logic for API response{title}{title}
				if pushlen == 5:
					if pushnotif['success'] == 1 and pushnotif['failure'] == 0 :
						updateStatus()
						updateDateMod()
						insertSvnTrans()
						querySuccess = (f"INSERT INTO svn_notif_maw (mobile_number, svn_id, attempt_count, attempt_status, date_created, date_modified, multicast_id,success,failure,canonical_ids,message_id,error_message, status_code, notif_type, svn_status) SELECT b.mobile_number, b.svn_id, 1, 'SUCCESS', NOW(), NOW(), '{pushnotif['multicast_id']}', '{pushnotif['success']}','{pushnotif['failure']}', '{pushnotif['canonical_ids']}','{pushnotif['results'][0]['message_id']}', NULL, '200', '{title}',a.status FROM svn a LEFT JOIN users b ON b.svn_id = a.id WHERE b.mobile_number='{mobileNum}'")
						cursor(querySuccess)
						afile.write('[{0}] You have Successfully sent notification to {1} \n'.format(currentTime, mobileNum))
						afile.write('[{0}] Message ID: {1} \n'.format(currentTime, pushnotif['results']))
					elif pushnotif['success'] == 0 and pushnotif['failure'] == 1:
						updateStatus()
						updateDateMod()
						insertSvnTrans()
						queryFailure = (f"INSERT INTO svn_notif_maw (mobile_number, svn_id, attempt_count, attempt_status, date_created, date_modified, multicast_id,success,failure,canonical_ids,message_id,error_message, status_code, notif_type, svn_status) SELECT b.mobile_number, b.svn_id, 0, 'RETRY', NOW(), NOW(), '{pushnotif['multicast_id']}', '{pushnotif['success']}','{pushnotif['failure']}', '{pushnotif['canonical_ids']}',NULL, '{pushnotif['results'][0]['error']}', '200', '{title}',a.status FROM svn a LEFT JOIN users b ON b.svn_id = a.id WHERE b.mobile_number='{mobileNum}'")
						cursor(queryFailure)
						afile.write('[{0}] Notification sending failed on mobile number {1} error message: {2} \n'.format(currentTime, mobileNum, pushnotif))
						retry_send()
					else:
						updateStatus()
						updateDateMod()
						insertSvnTrans()
						queryUnexpected = (f"INSERT INTO svn_notif_maw (mobile_number, svn_id, attempt_count, attempt_status, date_created, date_modified, multicast_id,success,failure,canonical_ids,message_id,error_message, status_code, notif_type, svn_status) SELECT b.mobile_number, b.svn_id, 0, 'RETRY', NOW(), NOW(), NULL, NULL,NULL, NULL, NULL, '{pushnotif['message']}, '200', '{title}',a.status FROM svn a LEFT JOIN users b ON b.svn_id = a.id WHERE b.mobile_number='{mobileNum}'")
						cursor(queryUnexpected)
						afile.write('[{0}] Unexpected error on {1} experiencing error {2} \n'.format(currentTime, mobileNum, pushnotif))
						retry_send()
				elif pushlen == 1:
					if pushnotif['message'] == 'Invalid number':
						updateStatus()
						updateDateMod()
						insertSvnTrans()
						queryInvalid = (f"INSERT INTO svn_notif_maw (mobile_number, svn_id, attempt_count, attempt_status, date_created, date_modified, multicast_id,success,failure,canonical_ids,message_id,error_message, status_code, notif_type, svn_status) SELECT b.mobile_number, b.svn_id, 0, 'RETRY', NOW(), NOW(), NULL, NULL,NULL, NULL, NULL, '{pushnotif['message']}', '200', '{title}',a.status FROM svn a LEFT JOIN users b ON b.svn_id = a.id WHERE b.mobile_number='{mobileNum}'")
						cursor(queryInvalid)
						afile.write('[{0}] The mobile number {1} is experiencing error {2} \n'.format(currentTime, mobileNum, pushnotif))
						retry_send()
					else:
						updateStatus()
						updateDateMod()
						insertSvnTrans()
						queryUnexpected = (f"INSERT INTO svn_notif_maw (mobile_number, svn_id, attempt_count, attempt_status, date_created, date_modified, multicast_id,success,failure,canonical_ids,message_id,error_message, status_code, notif_type, svn_status) SELECT b.mobile_number, b.svn_id, 0, 'RETRY', NOW(), NOW(), NULL, NULL,NULL, NULL, NULL, '{pushnotif['message']}', '200', '{title}',a.status FROM svn a LEFT JOIN users b ON b.svn_id = a.id WHERE b.mobile_number='{mobileNum}'")
						cursor(queryUnexpected)
						afile.write('[{0}] Unexpected error on {1} experiencing error {2} \n'.format(currentTime, mobileNum, pushnotif))
						retry_send()
				else:
					updateStatus()
					updateDateMod()
					insertSvnTrans()
					queryUnexpected = (f"INSERT INTO svn_notif_maw (mobile_number, svn_id, attempt_count, attempt_status, date_created, date_modified, multicast_id,success,failure,canonical_ids,message_id,error_message, status_code, notif_type, svn_status) SELECT b.mobile_number, b.svn_id, 0, 'RETRY', NOW(), NOW(), NULL, NULL,NULL, NULL, NULL, '{pushnotif['message']}', '200', '{title}',a.status FROM svn a LEFT JOIN users b ON b.svn_id = a.id WHERE b.mobile_number='{mobileNum}'")
					cursor(queryUnexpected)
					afile.write('[{0}] Unexpected error on {1} experiencing error {2} \n'.format(currentTime, mobileNum, pushnotif))
					retry_send()
			cur.close() # PostgresSQL connection is now closed
			conn.close()
		try:
			overall()
		except HTTPError as pushnotif_err:
			afile.write('[{0}] HTTP error: {1} \n'.format(currentTime, pushnotif_err))
		except Exception as pushnotif_uerr:
			afile.write('[{0}] Other error: {1} \n'.format(currentTime, pushnotif_uerr))
		finally:
			afile.write('[{0}] Successfully sent notifications for today... \n'.format(currentTime))
	afile.close()

### Create a new log.tmp file
def rewrite():
	f = open("/home/ec2-user/pushnotif/pushnotif34/logs.tmp","w+")
	f.write(f'[{currentTime}] Push Notifications - {title}. Sending notifications... \n')
	f.close()

#########################################################
#                   START OF PROGRAM                    #
#########################################################
rewrite()
main()
# end of code
