#!/usr/bin/env python
# -*- coding: utf-8 -*-

import psycopg2
import os

try:
	conn = psycopg2.connect("dbname='appvno' user='postgres' password='4332wurx'")
	print("Connected to appvno database.")
except:
	print("Unable to connect to appvno database.")

cur = conn.cursor()

try:
	list=open("currentNum.txt", "r")
	mobile=list.readline().strip()
	cur.execute("UPDATE notif_counter SET status='Pogi' WHERE mobile='{0}'".format(mobile))
	conn.commit();
	print("Table notif_counter where mobile {0} successfully updated.".format(mobile))
	list.close()
except:
	print("Failed to update the table for notif_counter")
finally:
	if(conn):
		cur.close()
		conn.close()
		print("PostgreSQL connection is closed.")
