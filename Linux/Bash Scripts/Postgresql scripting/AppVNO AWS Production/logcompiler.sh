#!/usr/bin/env bash

# This script is to complier all logs from Push Notification scripts.

# get the date today
DATE=$(date +"%m-%d-%y")
# 27 days log files
NOTIFYLOGS="/home/ec2-user/PushNotifcation/Notify27days/logs.tmp"
NOTIFYDIR="/home/ec2-user/PushNotifcation/Notify27days/logs"
# 30 days log files
EXPIRELOGS="/home/ec2-user/PushNotifcation/Expiry30days/logs.tmp"
EXPIREDIR="/home/ec2-user/PushNotifcation/Expiry30days/logs"
# 31 days log files
INACTIVELOGS="/home/ec2-user/PushNotifcation/Inactive31days/logs.tmp"
INACTIVEDIR="/home/ec2-user/PushNotifcation/Inactive31days/logs"
# 34 days log files
INCOMINGLOGS='/home/ec2-user/PushNotifcation/IncomingOnly34days/logs.tmp'
INCOMINGDIR='/home/ec2-user/PushNotifcation/IncomingOnly34days/logs'
# 86 days log files
COOLINGLOGS="/home/ec2-user/PushNotifcation/Cooling86days/logs.tmp"
COOLINGDIR="/home/ec2-user/PushNotifcation/Cooling86days/logs"
# 91 days log files
DEACTLOGS="/home/ec2-user/PushNotifcation/Deactivated91days/logs.tmp"
DEACTDIR="/home/ec2-user/PushNotifcation/Deactivated91days/logs"
# Number of backup days
BACKUP=60

# Notify
gzip -c $NOTIFYLOGS > $NOTIFYDIR/notify_logs_$DATE.gz
find $NOTIFYDIR -mtime $BACKUP -exec rm -R {} \;
# Expire
gzip -c $EXPIRELOGS > $EXPIREDIR/expire_logs_$DATE.gz
find $EXPIREDIR -mtime $BACKUP -exec rm -R {} \;
# Inactive
gzip -c $INACTIVELOGS > $INACTIVEDIR/inactive_logs_$DATE.gz
find $INACTIVEDIR -mtime $BACKUP -exec rm -R {} \;
# Incoming
gzip -c $INCOMINGLOGS > $INCOMINGDIR/incoming_logs_$DATE.gz
find $INCOMINGDIR -mtime $BACKUP -exec rm -R {} \;
# Cooling
gzip -c $COOLINGLOGS > $COOLINGDIR/cooling_logs_$DATE.gz
find $COOLINGDIR -mtime $BACKUP -exec rm -R {} \;
# Deactivate
gzip -c $DEACTLOGS > $DEACTDIR/deact_logs_$DATE.gz
find $DEACTDIR -mtime $BACKUP -exec rm -R {} \;

# END OF SCRIPT
