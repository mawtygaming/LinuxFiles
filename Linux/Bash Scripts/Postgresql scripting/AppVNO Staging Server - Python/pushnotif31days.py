import requests
import psycopg2
import os
import sys
from requests.exceptions import HTTPError
from datetime import datetime, timedelta

#################################################
#             Push Notification 31 days         #
#################################################
#
# 1. Update status of id on svn table from ACTIVE to INCOMING_SMS_ONLY.
# 2. Update the svn number date modified when you successfully updated the svn status.
# 3. Insert the information of logs on svn_transaction table.
#
#########################################################
#               DEFINING VARIABLES                      #
#########################################################

now = datetime.now()
currentTime = now.strftime("%b %d %Y %H:%M:%S")
# dateToday = now.strftime("%m-%d-%Y")
#expireDate = datetime.now() + timedelta(days = 3 )
#expireD = expireDate.strftime("%b-%d-%Y")

#########################################################
#               DEFINING FUNCTIONS                      #
#########################################################

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
	with open("/home/ec2-user/pushnotif/pushnotif31/logs.tmp","a+") as afile:

		### Function for overall program
		def overall():
			conn = psycopg2.connect(dbname='appvno',user='postgres',password='uGxEbkJKcPRnzgxHXOJy',host='10.10.24.18', port='5432') # success db
			cur = conn.cursor()
			cur.execute("SELECT a.mobile_number FROM users a LEFT JOIN svn b ON a.svn_id = b.id WHERE CURRENT_DATE - b.expiry_date::DATE = 1;")
			conn.commit();

			### This function is to select/alter database
			def cursor(query):
				cur = conn.cursor()
				cur.execute(query)
				conn.commit();

			row_count = cur.rowcount # This will count the rows
			result = [mobileNum[0] for mobileNum in cur.fetchall()] # This is the list of mobile numbers on the query

			for mobileNum in result: # Mobile number 1 by 1 until all the rows are done
				try: # update svn status to INCOMING_SMS_ONLY
					queryUpdate=(f"UPDATE svn SET status='INCOMING_SMS_ONLY' WHERE id = (SELECT svn_id FROM users WHERE mobile_number = '{mobileNum}')")
					cursor(queryUpdate)
					afile.write(f'[{currentTime}] Successfully updated svn status from ACTIVE to INCOMING_SMS_ONLY of mobile number {mobileNum} \n')
				except Exception as update_err1:
					afile.write(f'[{currentTime}] Unsucessful to update svn status of mobile number {mobileNum} \n')
					afile.write(f'[{currentTime}] Getting error {update_err1} on mobile number {mobileNum} \n')
				try: # This will update data modified of svn
					queryUpdate1=(f"UPDATE svn SET date_modified=NOW() WHERE id = (SELECT svn_id FROM users WHERE mobile_number = '{mobileNum}')")
					cursor(queryUpdate1)
					afile.write(f'[{currentTime}] Successfully updated svn date modified of mobile number {mobileNum} \n')
				except Exception as update_err2:
					afile.write(f'[{currentTime}] Unsucessful to update svn date modified of mobile number {mobileNum} \n')
					afile.write(f'[{currentTime}] Getting error {update_err2} on mobile number {mobileNum} \n')
				try: # This insert data on svn_transactions table
					queryInsert=(f"INSERT INTO svn_transactions(mobile_number, svn_id, svn_status, date_subscribed, expiry_date, date_created, record_status) SELECT b.mobile_number, b.svn_id, a.status, a.date_subscribed, a.expiry_date, NOW(), 'ACTIVE' FROM svn a LEFT JOIN users b ON a.id = b.svn_id WHERE b.mobile_number='{mobileNum}';")
					cursor(queryInsert)
					afile.write(f'[{currentTime}] Successfully updated svn transaction for {mobileNum} \n')
				except Exception as update_err3:
					afile.write(f'[{currentTime}] Unsucessful to update svn transaction of mobile number {mobileNum} \n')
					afile.write(f'[{currentTime}] Getting error {update_err3} on mobile number {mobileNum} \n')
			cur.close() # PostgresSQL connection is now closed
			conn.close()
		try:
			overall()
		except HTTPError as pushnotif_err:
			afile.write('[{0}] HTTP error on getting token: {1} \n'.format(currentTime, pushnotif_err))
		except Exception as pushnotif_uerr:
			afile.write('[{0}] Other error on getting token: {1} \n'.format(currentTime, pushnotif_uerr))
		finally:
			afile.write('[{0}] Successfully updated svn database for today... \n'.format(currentTime))
	afile.close()

### Create a new log.tmp file
def rewrite():
	f = open("/home/ec2-user/pushnotif/pushnotif31/logs.tmp","w+")
	f.write('[{0}] Push Notifications - 31st day Expiration Date. Updating database... \n'.format(currentTime))
	f.close()

#########################################################
#                   START OF PROGRAM                    #
#########################################################
rewrite()
main()
# end of code
