#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This script is to test database connection

import psycopg2
import os
import sys

try:
	conn = psycopg2.connect(dbname='appvno', user='postgres', password='qXmQW9YKnb1U4rOOFbDz', host='10.10.169.78', port='5432')
	print("Connected to appvno database.")
except:
	print("Unable to connect to appvno database.")

