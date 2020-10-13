#!/bin/bash

TODAY=$(date +"%Y-%m-%d")

# create a directory
mkdir /data/logs/messaging/logs/all_logs_$TODAY
mkdir /data/logs/messaging/logs/debug_logs_$TODAY

sleep 5s
# copy log files
mv /data/logs/messaging/all.txt* /data/logs/messaging/logs/all_logs_$TODAY
mv /data/logs/messaging/debug.txt* /data/logs/messaging/logs/debug_logs_$TODAY

sleep 5s

# gzip
cd /data/logs/messaging/logs/
tar -zcvf all_logs_$TODAY.tar.gz all_logs_$TODAY
tar -zcvf debug_logs_$TODAY.tar.gz debug_logs_$TODAY

sleep 5s

# removing files
rm -f -R /data/logs/messaging/logs/all_logs_$TODAY
rm -f -R /data/logs/messaging/logs/debug_logs_$TODAY

# end of script
