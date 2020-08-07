#!/usr/bin/env python
# -*- coding: utf-8 -*-

import psycopg2
import os
import sys
from datetime import datetime

now = datetime.now()
currentTime = now.strftime("%b %d %Y %H:%M:%S")

#  This script is to SELECT all ids from users with 30 days counter.

try:
        conn = psycopg2.connect(dbname='appvno', user='postgres', password='uGxEbkJKcPRnzgxHXOJy', host='10.10.24.18', port='5432')
#       print("Connected to appvno database.")
except:
        unable_stdout = sys.stdout
        unable = open("logs.tmp", "a")
        sys.stdout = unable
        print("[{0}] Unable to connect to appvno database.".format(currentTime))
        sys.stdout = unable_stdout
        unable.close()

# SELECT all mobile numbers from users table using svn numbers from svn table- counter 30 days.
try:
        cur = conn.cursor()
        cur.execute("SELECT a.mobile_number FROM users a LEFT JOIN svn b ON a.svn_id = b.id WHERE expiry_date::DATE = current_date")
# Print results to list.tmp
        result = cur.fetchall()
        list_stdout = sys.stdout
        list = open("list30days.tmp", "w")
        sys.stdout = list
        for row in result:
                print(row[0])
        sys.stdout = list_stdout
        list.close()
# Logs success query.
        query_stdout = sys.stdout
        query = open("logs.tmp", "a")
        sys.stdout = query
        print("[{0}] Successfuly selected mobiles numbers from users table using svn number...".format(currentTime))
        sys.stdout = query_stdout
        query.close()
except:
# Print result of failed select.
        failed_stdout = sys.stdout
        failed = open("logs.tmp", "a")
        sys.stdout = failed
        print("[{0}] Failed to select data.".format(currentTime))
        sys.stdout = failed_stdout
        failed.close()
# This is to overwrite list.tmp with no text inserted. To make sure no mobile numbers will be curl again.
        ov_stdout = sys.stdout
        ov = open("list30days.tmp", "w")
        sys.stdout = ov
        print(" ")
        sys.stdout = ov_stdout
        ov.close()
finally:
# Closed postgresql connection
        if(conn):
                cur.close()
                conn.close()
                # print("PostgreSQL connection is closed.")

# end of script

