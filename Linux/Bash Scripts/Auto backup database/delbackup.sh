#! /bin/bash
# Auto delete files
# 1. Create a root own .sh file
# 2. Set crontime on 0:15 am via root crontab -e

DBACKUP_DAYS=7 
WBACKUP_DAYS=30 
MBACKUP_DAYS=90 
DPATH='/home/vpms-rufino/HoiyDatabaseBackup/daily' 
WPATH='/home/vpms-rufino/HoiyDatabaseBackup/weekly' 
MPATH='/home/vpms-rufino/HoiyDatabaseBackup/monthly' 


find ${DBPATH} -mtime +${DBACKUP_DAYS} -exec rm -R {} \; 
find ${WPATH} -mtime +${WBACKUP_DAYS} -exec rm -R {} \; 
find ${MPATH} -mtime +${MBACKUP_DAYS} -exec rm -R {} \;

#find /home/vpms-rufino/Database_Backup/daily -mtime 0 -exec rm -R {} \;
#find /home/vpms-rufino/Database_Backup/weekly -mtime 0 -exec rm -R {} \;
#find /home/vpms-rufino/Database_Backup/monthly -mtime 0 -exec rm -R {} \;


#end of script
=========================================================================
#! /bin/bash

automysqlbackup

# end of script

============================================================================

