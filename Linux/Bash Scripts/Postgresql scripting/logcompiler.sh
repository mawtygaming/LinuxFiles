#!/usr/bin/env bash

# get the date today
DATE=$(date +"%m-%d-%y")
# 27 days log files
NOTIFYLOGS="/var/lib/postgresql/PushNotification/Notify27days/logs.tmp"
NOTIFYDIR="/var/lib/postgresql/PushNotification/Notify27days/logs"
# 30 days log files
EXPIRELOGS="/var/lib/postgresql/PushNotification/Expired30days/logs.tmp"
EXPIREDIR="/var/lib/postgresql/PushNotification/Expired30days/logs"
# 31 days log files
INACTIVELOGS="/var/lib/postgresql/PushNotification/Inactive31days/logs.tmp"
INACTIVEDIR="/var/lib/postgresql/PushNotification/Inactive31days/logs"
# 86 days log files 
COOLINGLOGS="/var/lib/postgresql/PushNotification/Cooling86days/logs.tmp"
COOLINGDIR="/var/lib/postgresql/PushNotification/Cooling86days/logs"
# 91 days log files
DEACTLOGS="/var/lib/postgresql/PushNotification/Deactivated91days/logs.tmp"
DEACTDIR="/var/lib/postgresql/PushNotification/Deactivated91days/logs"
# Number of backup days
BACKUP=60

# Notify
gzip -c $NOTIFYLOGS > $NOTIFYDIR/notify27logs_$DATE.gz
find $NOTIFYDIR -mtime $BACKUP -exec rm -R {} \;
# Expire
gzip -c $EXPIRELOGS > $EXPIREDIR/notify27logs_$DATE.gz
find $EXPIREDIR -mtime $BACKUP -exec rm -R {} \;
# Inactive
gzip -c $INACTIVELOGS > $INACTIVEDIR/notify27logs_$DATE.gz
find $INACTIVEDIR -mtime $BACKUP -exec rm -R {} \;
# Cooling
gzip -c $COOLINGLOGS > $COOLINGDIR/notify27logs_$DATE.gz
find $COOLINGDIR -mtime $BACKUP -exec rm -R {} \;
# Deactivate
gzip -c $DEACTLOGS > $DEACTDIR/notify27logs_$DATE.gz
find $DEACTDIR -mtime $BACKUP -exec rm -R {} \;

# END OF SCRIPT