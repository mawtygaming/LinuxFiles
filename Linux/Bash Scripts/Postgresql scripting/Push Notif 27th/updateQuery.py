#!/usr/bin/env python
# -*- coding: utf-8 -*-

import psycopg2
import os
import sys
from datetime import datetime

now = datetime.now()
currentTime = now.strftime("%b %d %Y %H:%M:%S")

try:
	conn = psycopg2.connect("dbname='appvno' user='postgres' password='4332wurx'")
#	print("Connected to appvno database.")
except:
	unable_stdout = sys.stdout
	unable = open("logs.txt", "a")
	sys.stdout = unable
	print("[{0}] Unable to connect to appvno database.".format(currentTime))
	sys.stdout = unable_stdout
	unable.close()

cur = conn.cursor()

try:
	list=open("currentNum.txt", "r")
	mobile=list.readline().strip()
	cur.execute("UPDATE notif_counter SET status='Notified' WHERE mobile='{0}'".format(mobile))
	conn.commit();
	success_stdout = sys.stdout
	success = open("logs.txt", "a")
	sys.stdout = success
	print("[{1}] Table notif_counter with  mobile {0} was successfully updated.".format(mobile, currentTime))
	sys.stdout = success_stdout
	success.close()
	list.close()
except:
	failed_stdout = sys.stdout
	failed = open("logs.txt", "a")
	sys.stdout = failed
	print("[{0}] Failed to update the table for notif_counter.".format(currentTime))
	sys.stdout = failed_stdout
	failed.close()
finally:
	if(conn):
		cur.close()
		conn.close()
#		print("PostgreSQL connection is closed.")
