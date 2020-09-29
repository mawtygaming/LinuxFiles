#!/bin/bash

TODAY=$(date +"%Y-%m-%d")

# copy log files 
cp /data/logs/messaging/all.log /data/logs/messaging/logs/
cp /data/logs/messaging/info.log /data/logs/messaging/logs/
cp /data/logs/messaging/warn.log /data/logs/messaging/logs/
cp /data/logs/messaging/debug.log /data/logs/messaging/logs/
cp /data/logs/messaging/error.log /data/logs/messaging/logs/

sleep 5s
# renaming files
mv /data/logs/messaging/logs/all.log /data/logs/messaging/logs/all_$TODAY.log
mv /data/logs/messaging/logs/info.log /data/logs/messaging/logs/info_$TODAY.log
mv /data/logs/messaging/logs/warn.log /data/logs/messaging/logs/warn_$TODAY.log
mv /data/logs/messaging/logs/debug.log /data/logs/messaging/logs/debug_$TODAY.log
mv /data/logs/messaging/logs/error.log /data/logs/messaging/logs/error_$TODAY.log

sleep 5s

# zipping a file
gzip -f /data/logs/messaging/logs/all_$TODAY.log > /data/logs/messaging/logs/all_$TODAY.log.gz
gzip -f /data/logs/messaging/logs/info_$TODAY.log > /data/logs/messaging/logs/info_$TODAY.log.gz
gzip -f /data/logs/messaging/logs/warn_$TODAY.log > /data/logs/messaging/logs/warn_$TODAY.log.gz
gzip -f /data/logs/messaging/logs/debug_$TODAY.log > /data/logs/messaging/logs/debug_$TODAY.log.gz
gzip -f /data/logs/messaging/logs/error_$TODAY.log > /data/logs/messaging/logs/error_$TODAY.log.gz

# end of script

