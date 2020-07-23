#!/usr/bin/env python
# -*- coding: utf-8 -*-

import psycopg2
import os
import sys
from datetime import datetime

now = datetime.now()
currentTime = now.strftime("%b %d %Y %H:%M:%S")

# Try to connect to database
try:
	conn = psycopg2.connect("dbname='appvno_latest' user='postgres' password='4332wurx'")
#	print("Connected to appvno database.")
except:
	unable_stdout = sys.stdout
	unable = open("logs.tmp", "a")
	sys.stdout = unable
	print("[{0}] Unable to connect to appvno database.".format(currentTime))
	sys.stdout = unable_stdout
	unable.close()

cur = conn.cursor()

# Update mobile number status into UNASSIGNED
try:
	list=open("currentNum.txt", "r")
	mobile=list.readline().strip()
	cur.execute("UPDATE svn SET status='UNASSIGNED' WHERE id='{0}'".format(mobile))
	conn.commit();
	success_stdout = sys.stdout
	success = open("logs.tmp", "a")
	sys.stdout = success
	print("[{1}] Mobile {0} was successfully updated status into UNASSIGNED.".format(mobile, currentTime))
	sys.stdout = success_stdout
	success.close()
	list.close()
except:
	failed_stdout = sys.stdout
	failed = open("logs.tmp", "a")
	sys.stdout = failed
	print("[{0}] Failed to update the table.".format(currentTime))
	sys.stdout = failed_stdout
	failed.close()
	
# Update svn table date_modified
try:
	list=open("currentNum.txt", "r")
	mobile=list.readline().strip()
	cur.execute("UPDATE svn SET date_modified=NOW() WHERE id='{0}'".format(mobile))
	conn.commit();
	svnupdate_stdout = sys.stdout
	svnupdate = open("logs.tmp", "a")
	sys.stdout = svnupdate
	print("[{1}] Mobile {0} date_modified was successfully updated on svn table.".format(mobile, currentTime))
	sys.stdout = svnupdate_stdout
	svnupdate.close()
	list.close()
except:
	svnfailed_stdout = sys.stdout
	svnfailed = open("logs.tmp", "a")
	sys.stdout = svnfailed
	print("[{0}] Failed to update date_modified on svn table.".format(currentTime))
	sys.stdout = svnfailed_stdout
	svnfailed.close()

# Update users table into NULL
try:
	list=open("currentNum.txt", "r")
	mobile=list.readline().strip()
	cur.execute("UPDATE users SET svn_id = NULL WHERE mobile_number='{0}'".format(mobile))
	conn.commit();
	nullsuccess_stdout = sys.stdout
	nullsuccess = open("logs.tmp", "a")
	sys.stdout = nullsuccess
	print("[{1}] Mobile {0} svn_id successfully updated into NULL.".format(mobile, currentTime))
	sys.stdout = nullsuccess_stdout
	nullsuccess.close()
	list.close()
except:
	nullfailed_stdout = sys.stdout
	nullfailed = open("logs.tmp", "a")
	sys.stdout = nullfailed
	print("[{0}] Failed to update the table.".format(currentTime))
	sys.stdout = nullfailed_stdout
	nullfailed.close()
	
# Update users table date_modified
try:
	list=open("currentNum.txt", "r")
	mobile=list.readline().strip()
	cur.execute("UPDATE users SET date_modified=NOW() WHERE mobile_number='{0}'".format(mobile))
	conn.commit();
	svnupdate_stdout = sys.stdout
	svnupdate = open("logs.tmp", "a")
	sys.stdout = svnupdate
	print("[{1}] Mobile {0} date_modified was successfully updated on users table.".format(mobile, currentTime))
	sys.stdout = svnupdate_stdout
	svnupdate.close()
	list.close()
except:
	svnfailed_stdout = sys.stdout
	svnfailed = open("logs.tmp", "a")
	sys.stdout = svnfailed
	print("[{0}] Failed to update date_modified on svn table.".format(currentTime))
	sys.stdout = svnfailed_stdout
	svnfailed.close()
	
# Insert svn_transaction table 
try:
	list=open("currentNum.txt", "r")
	mobile=list.readline().strip()
	cur.execute("INSERT INTO svn_transactions(mobile_number, svn_id, svn_status, date_subscribed, expiry_date, date_created) SELECT b.mobile_number, b.svn_id, a.status, a.date_subscribed, a.expiry_date, NOW() FROM svn a, users b WHERE a.id='{0}' and b.mobile_number='{0}'".format(mobile))
	conn.commit();
	transacupdate_stdout = sys.stdout
	transacupdate = open("logs.tmp", "a")
	sys.stdout = transacupdate
	print("[{1}] Mobile {0} inserted into svn_transaction table".format(mobile, currentTime))
	sys.stdout = transacupdate_stdout
	transacupdate.close()
	list.close()
except:
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
