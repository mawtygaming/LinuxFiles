#!/usr/bin/env python
# -*- coding: utf-8 -*-

import psycopg2
import os
import sys
from datetime import datetime

now = datetime.now()
currentTime = now.strftime("%b %d %Y %H:%M:%S")

try:
	conn = psycopg2.connect("dbname='latest_appvno' user='postgres' password='4332wurx'")
#	print("Connected to appvno database.")
except:
	unable_stdout = sys.stdout
	unable = open("logs.tmp", "a")
	sys.stdout = unable
	print("[{0}] Unable to connect to appvno database.".format(currentTime))
	sys.stdout = unable_stdout
	unable.close()

cur = conn.cursor()

try:
	list=open("currentNum.txt", "r")
	mobile=list.readline().strip()
	cur.execute("UPDATE users SET svn_id = NULL WHERE mobile_number='{0}'".format(mobile))
	conn.commit();
	success_stdout = sys.stdout
	success = open("logs.tmp", "a")
	sys.stdout = success
	print("[{1}] Mobile {0} with svn_id successfully updated into NULL.".format(mobile, currentTime))
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
finally:
	if(conn):
		cur.close()
		conn.close()
#		print("PostgreSQL connection is closed.")
