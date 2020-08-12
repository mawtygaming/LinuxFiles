#!/usr/bin/env python
# -*- coding: utf-8 -*-

import psycopg2
import os
import sys
from datetime import datetime

now = datetime.now()
currentTime = now.strftime("%b %d %Y %H:%M:%S")

try:
	conn = psycopg2.connect(dbname='appvno', user='postgres', password='qXmQW9YKnb1U4rOOFbDz', host='10.10.169.78', port='5432')
#       print("Connected to appvno database.")
except:
	unable_stdout = sys.stdout
	unable = open("logs.tmp", "a")
	sys.stdout = unable
	print("[{0}] Unable to connect to appvno database.".format(currentTime)) 
	sys.stdout = unable_stdout
	unable.close()

cur = conn.cursor()

# Update mobile number status into EXPIRED
try:
	list=open("currentNum.tmp", "r")
	mobile=list.readline().strip()
	cur.execute("UPDATE svn SET status='EXPIRED' FROM users WHERE users.mobile_number = '{0}' AND svn.id = users.svn_id".format(mobile))
	conn.commit();
# Logs
	success_stdout = sys.stdout
	success = open("logs.tmp", "a")
	sys.stdout = success
	print("[{1}] Mobile {0} was successfully updated status into EXPIRED.".format(mobile, currentTime))
	sys.stdout = success_stdout
	success.close()
	list.close()
except:
# Logs
	failed_stdout = sys.stdout
	failed = open("logs.tmp", "a")
	sys.stdout = failed
	print("[{0}] Failed to update the table.".format(currentTime))
	sys.stdout = failed_stdout
	failed.close()

# Update svn table date_modified
try:
	list=open("currentNum.tmp", "r")
	mobile=list.readline().strip()
	cur.execute("UPDATE svn SET date_modified=NOW() FROM users WHERE users.mobile_number = '{0}' AND svn.id = users.svn_id".format(mobile))
	conn.commit();
# Logs
	svnupdate_stdout = sys.stdout
	svnupdate = open("logs.tmp", "a")
	sys.stdout = svnupdate
	print("[{1}] Mobile {0} date_modified was successfully updated.".format(mobile, currentTime))
	sys.stdout = svnupdate_stdout
	svnupdate.close()
	list.close()
except:
# Logs
	svnfailed_stdout = sys.stdout
	svnfailed = open("logs.tmp", "a")
	sys.stdout = svnfailed
	print("[{0}] Failed to update date_modified on svn table.".format(currentTime))
	sys.stdout = svnfailed_stdout
	svnfailed.close()

# Insert svn_transaction table
try:
	list=open("currentNum.tmp", "r")
	mobile=list.readline().strip()
	cur.execute("INSERT INTO svn_transactions(mobile_number, svn_id, svn_status, date_subscribed, expiry_date, date_created,record_status) SELECT b.mobile_number, b.svn_id, a.status, a.date_subscribed, a.expiry_date, NOW(), 'ACTIVE' FROM svn a, users b WHERE b.mobile_number='{0}'".format(mobile))
	conn.commit();
# Logs
	transacupdate_stdout = sys.stdout
	transacupdate = open("logs.tmp", "a")
	sys.stdout = transacupdate
	print("[{1}] Mobile {0} inserted into svn_transaction table".format(mobile, currentTime))
	sys.stdout = transacupdate_stdout
	transacupdate.close()
	list.close()
except:
# Logs
	transacfailed_stdout = sys.stdout
	transacfailed = open("logs.tmp", "a")
	sys.stdout = transacfailed
	print("[{0}] Failed to insert into svn_transaction table.".format(currentTime))
	sys.stdout = transacfailed_stdout
	transacfailed.close()
finally:
	if(conn):
		cur.close()
		conn.close()
#		print("PostgreSQL connection is closed.")

# end of script
