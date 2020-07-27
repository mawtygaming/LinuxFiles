#!/usr/bin/env python
# -*- coding: utf-8 -*-

import psycopg2
import os
import sys

# This script is to test connection to database

try:
	conn = psycopg2.connect(dbname='appvno', user='postgres', password='uGxEbkJKcPRnzgxHXOJy', host='10.10.24.18', port='5432')
	print("Connected to appvno database.")
except:
	print("Unable to connect to appvno database.")

# end of script
